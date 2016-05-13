defmodule Shorty.Router do
  use Plug.Router
  use Timex

  if Mix.env == :dev do
    use Plug.Debugger
    plug Plug.Logger, log: :debug
  end

  alias Shorty.Repo

  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :match
  plug :dispatch

  @error_map %{
    url_not_present:          400,
    shortcode_already_exists: 409,
    invalid_shortcode:        422,
    shortcode_not_found:      404
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
    code    = @error_map[error] || 500
    message = String.replace(to_string(error), "_", " ")

    conn
    |> set_content_type
    |> send_resp(code, render_message(message, "error"))
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
