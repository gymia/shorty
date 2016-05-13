defmodule ShortyRepoTest do
  use ExUnit.Case

  import Mock

  alias Shorty.Repo
  alias Shorty.Entry

  @valid_code "XXXXXX"
  @invalid_code "*******"
  @url "http://www.google.com"

  setup do
    Shorty.Repo.reset && :ok
  end

  test "put with a non-existing shortcode" do
    assert {:ok, @valid_code} == Repo.put(@url, @valid_code)
  end

  test "put without a shortcode" do
    assert {:ok, shortcode} = Repo.put(@url)
    assert Entry.validate_shortcode(shortcode)
  end

  test "put without a shortcode (with a shortcode collision)" do
    with_mock Entry, [
      validate: fn(_) -> :ok end,
      generate_shortcode: fn(counter) ->
        case counter do
          0 -> "YYYYYY"
          1 -> @valid_code
        end
      end
    ] do

      assert "YYYYYY" == Repo.generate_unique_shortcode(%{})
      assert @valid_code == Repo.generate_unique_shortcode(%{"YYYYYY" => true})
    end
  end

  test "put with an existing shortcode" do
    assert {:ok, @valid_code} == Repo.put(@url, @valid_code)
    assert {:error, :shortcode_already_exists} == Repo.put(@url, @valid_code)
  end

  test "put with an invalid shortcode" do
    assert {:error, :invalid_shortcode} == Repo.put(@url, @invalid_code)
  end

  test "put with a nil url" do
    assert {:error, :url_not_present} == Repo.put(nil, @valid_code)
  end

  test "put with a blank url" do
    assert {:error, :url_not_present} == Repo.put("  ", @valid_code)
  end

  test "get with an existing shortcode" do
    assert {:ok, shortcode} = Repo.put(@url)
    assert {:ok, %{url: @url,
                   display_count: 0,
                   start_date: %Timex.DateTime{},
                   displayed_at: nil}} = Repo.get(shortcode)
  end

  test "get with an non-existing shortcode" do
    assert {:error, :shortcode_not_found} == Repo.get(@valid_code)
  end

  test "display with a non-existing shortcode" do
    assert {:error, :shortcode_not_found} == Repo.display(@valid_code)
  end

  test "display with an existing shortcode" do
    assert {:ok, shortcode} = Repo.put(@url)
    assert {:ok, @url} == Repo.display(shortcode)
    assert {:ok, %{url: @url,
                   display_count: 1,
                   start_date: %Timex.DateTime{},
                   displayed_at: %Timex.DateTime{}}} = Repo.get(shortcode)
  end

  test "debug" do
    assert {:ok, shortcode} = Repo.put(@url)
    assert %{
      ^shortcode => %{
        url: @url,
        display_count: 0,
        start_date: %Timex.DateTime{},
        displayed_at: nil
      }
    } = Repo.debug
  end
end
