defmodule ShortyEntryTest do
  use ExUnit.Case

  alias Shorty.Entry

  @shortcode_pattern ~r/^[0-9a-zA-Z_]{6}$/
  @shortcode_char_pattern ~r/^[0-9a-zA-Z_]{1}$/

  test "validate_shortcode with accept_nil true" do
    assert Entry.validate_shortcode("XXXXXX")
    assert Entry.validate_shortcode(nil)
    assert !Entry.validate_shortcode("XX")
    assert !Entry.validate_shortcode("******")
  end

  test "validate_shortcode with accept_nil false" do
    assert Entry.validate_shortcode("XXXXXX", false)
    assert !Entry.validate_shortcode(nil, false)
    assert !Entry.validate_shortcode("XX", false)
    assert !Entry.validate_shortcode("******", false)
  end

  test "validate_url" do
    assert Entry.validate_url("XX")
    assert !Entry.validate_url(nil)
    assert !Entry.validate_url("")
    assert !Entry.validate_url("  ")
  end

  test "generate_shortcode" do
    shortcode = Entry.generate_shortcode
    assert String.match?(shortcode, @shortcode_pattern)
  end

  test "pick_shortcode_character" do
    character = Entry.pick_shortcode_character
    assert String.match?(character, @shortcode_char_pattern)
  end
end
