defmodule Shorty.Router do
  use Plug.Router
  use Timex

  if Mix.env == :dev do
    use Plug.Debugger
    plug Plug.Logger, log: :debug
  end

  if Mix.env == :prod do
    plug Plug.Logger, log: :info
  end

  alias Shorty.Repo

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  @errors %{
    url_not_present:          {400, "\"url\" not present."},
    shortcode_already_exists: {409, "The the desired shortcode is already in use (Shortcodes are case-sensitive)."},
    invalid_shortcode:        {422, "The shortcode fails to meet the following regexp: \"^[0-9a-zA-Z_]{4,}$\""},
    shortcode_not_found:      {404, "The \"shortcode\" cannot be found in the system."}
  }

  get "/" do
    conn
    |> set_content_type
    |> send_resp(200, render_message("Hi from Shorty!"))
  end

  post "/shorten" do
    case Repo.put(conn.params["url"], conn.params["shortcode"]) do
      {:ok, shortcode} ->
        conn
        |> set_content_type
        |> send_resp(201, render_shortcode(shortcode))
      {:error, error} ->
        send_error(conn, error)
    end
  end

  get "/:shortcode" do
    case Repo.display(shortcode) do
      {:ok, url} ->
        conn
        |> put_resp_header("location", url)
        |> send_resp(302, "")
      {:error, error} ->
        send_error(conn, error)
    end
  end

  get "/:shortcode/stats" do
    case Repo.get(shortcode) do
      {:ok, stats} ->
        conn
        |> set_content_type
        |> send_resp(200, render_stats(stats))
      {:error, error} ->
        send_error(conn, error)
    end
  end

  match _ do
    conn
    |> set_content_type
    |> send_resp(404, render_message("not found", "error"))
  end

  defp set_content_type(conn) do
    conn
    |> put_resp_content_type("application/json")
  end

  defp send_error(conn, error) do
    {code, message} = @errors[error]

    conn
    |> set_content_type
    |> send_resp(code || 500, render_message(message || to_string(error), "error"))
  end

  defp format_timestamp(timestamp) do
    case timestamp do
      nil -> nil
      _   -> Timex.format!(timestamp, "{ISOz}")
    end
  end

  defp render_shortcode(shortcode) do
    Poison.encode!(%{
      "shortcode" => shortcode
    })
  end

  defp render_message(message, key \\ "message") do
    Poison.encode!(%{key => message})
  end

  defp render_stats(stats) do
    Poison.encode!(%{
      "startDate"     => format_timestamp(stats.start_date),
      "lastSeenDate"  => format_timestamp(stats.displayed_at),
      "redirectCount" => stats.display_count
    })
  end
end
