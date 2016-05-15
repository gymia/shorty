defmodule Shorty.Entry do
  @shortcode_pattern ~r/^[0-9a-zA-Z_]{4,}$/

  def validate(url: url, shortcode: shortcode) do
    case {validate_url(url), validate_shortcode(shortcode)} do
      {false, _} ->
        {:error, :url_not_present}
      {true, false} ->
        {:error, :invalid_shortcode}
      _ ->
        :ok
    end
  end

  def validate_shortcode(shortcode, accept_nil \\ true) do
    case shortcode do
      nil -> accept_nil
      _   -> String.match?(shortcode, @shortcode_pattern)
    end
  end

  def validate_url(url) do
    case url do
      nil -> false
      str -> String.strip(str) != ""
    end
  end

  def generate_shortcode(_count \\ 0) do
    1..6
    |> Enum.map(fn(_) -> pick_shortcode_character end)
    |> Enum.join
  end

  def pick_shortcode_character do
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
    |> String.codepoints
    |> Enum.random
  end
end
