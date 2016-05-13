defmodule ShortyRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  import Mock

  alias Shorty.Repo
  alias Shorty.Router

  @opts     Router.init([])
  @code     "XXXXXX"
  @now      Timex.datetime({{2012, 04, 23}, {18, 25, 43, 51}})
  @now_str  "2012-04-23T18:25:43.511Z"
  @url      "http://google.com"
  @stats    %{url: @url, displayed_at: nil, display_count: 0, start_date: @now}

  def post(url, params \\ %{}) do
    conn(:post, url, Poison.encode!(params))
    |> put_req_header("content-type", "application/json")
    |> Router.call(@opts)
  end

  def get(url) do
    conn(:get, url)
    |> Router.call(@opts)
  end

  def assert_content_type(conn) do
    assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
  end

  test "get /" do
    conn = get("/")

    assert_content_type conn
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"message\":\"Hi from Shorty!\"}"
  end

  test "successful post /shorten without a code" do
    with_mock Repo, [
      put: fn(@url, _) -> {:ok, @code} end
    ] do
      conn = post("/shorten", %{"url" => @url})

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 201
      assert conn.resp_body == "{\"shortcode\":\"XXXXXX\"}"
    end
  end

  test "successful post /shorten with a code" do
    with_mock Repo, [
      put: fn(@url, code) -> {:ok, code} end
    ] do
      conn = post("/shorten", %{"url" => @url, "shortcode" => "YYYYYY"})

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 201
      assert conn.resp_body == "{\"shortcode\":\"YYYYYY\"}"
    end
  end

  test "failed post /shorten" do
    with_mock Repo, [
      put: fn(_, _) -> {:error, :url_not_present} end
    ] do
      conn = post("/shorten")

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "{\"error\":\"\\\"url\\\" not present.\"}"
    end
  end

  test "successful get /:shortcode" do
    with_mock Repo, [
      display: fn("SHORT_CODE") -> {:ok, @url} end
    ] do
      conn = get("/SHORT_CODE")

      assert conn.state == :sent
      assert conn.status == 302
      assert get_resp_header(conn, "location") == [@url]
    end
  end

  test "failed get /:shortcode" do
    with_mock Repo, [
      display: fn("SHORT_CODE") -> {:error, :shortcode_not_found} end
    ] do
      conn = get("/SHORT_CODE")

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "{\"error\":\"The \\\"shortcode\\\" cannot be found in the system.\"}"
    end
  end

  test "successful get /:shortcode/stats" do
    with_mock Repo, [
      get: fn("SHORT_CODE") -> {:ok, @stats} end
    ] do
      conn = get("/SHORT_CODE/stats")

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "{\"startDate\":\"2012-04-23T18:25:43.051Z\",\"redirectCount\":0,\"lastSeenDate\":null}"
    end
  end

  test "failed get /:shortcode/stats" do
    with_mock Repo, [
      get: fn("SHORT_CODE") -> {:error, :shortcode_not_found} end
    ] do
      conn = get("/SHORT_CODE/stats")

      assert_content_type conn
      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "{\"error\":\"The \\\"shortcode\\\" cannot be found in the system.\"}"
    end
  end

  test "catchall" do
    conn = get("/unknown_path/should_fail")

    assert_content_type conn
    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "{\"error\":\"not found\"}"
  end
end
