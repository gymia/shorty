defmodule Shorty.Entry do
  @shortcode_chars String.codepoints("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
  @shortcode_length 6
  @shortcode_pattern ~r/^[0-9a-zA-Z_]{6}$/

  def validate(url: url, shortcode: shortcode) do
    case validate_url(url) do
      :ok   -> validate_shortcode(shortcode)
      error -> error
    end
  end

  def validate_shortcode(shortcode) do
    if is_nil(shortcode) || String.match?(shortcode, @shortcode_pattern) do
      :ok
    else
      {:error, :invalid_shortcode}
    end
  end

  def validate_url(url) do
    cond do
      is_nil(url) ->
        {:error, :url_not_present}
      String.strip(url) == "" ->
        {:error, :url_not_present}
      true ->
        :ok
    end
  end

  def generate_shortcode(_count \\ 0) do
    1..@shortcode_length
    |> Enum.map(fn(_) -> pick_shortcode_character end)
    |> Enum.join
  end

  def pick_shortcode_character do
    @shortcode_chars |> Enum.random
  end
end
