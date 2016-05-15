defmodule Shorty.Repo do
  use GenServer
  use Timex

  alias Shorty.Entry

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Client API

  def put(url, shortcode \\ nil) do
    case Entry.validate(url: url, shortcode: shortcode) do
      :ok   -> GenServer.call(__MODULE__, {:put, url, shortcode})
      error -> error
    end
  end

  def get(shortcode) do
    GenServer.call(__MODULE__, {:get, shortcode})
  end

  def display(shortcode) do
    GenServer.call(__MODULE__, {:display, shortcode})
  end

  def debug do
    GenServer.call(__MODULE__, :debug)
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  # Server API

  def handle_call({:get, shortcode}, _from, state) do
    case Map.fetch(state, shortcode) do
      {:ok, value} ->
        {:reply, {:ok, value}, state}
      :error ->
        {:reply, {:error, :shortcode_not_found}, state}
    end
  end

  def handle_call({:display, shortcode}, _from, state) do
    case Map.fetch(state, shortcode) do
      {:ok, value} ->
        %{display_count: display_count} = value

        value = Map.merge(value, %{
          display_count: display_count + 1,
          displayed_at:  DateTime.now
        })

        {:reply, {:ok, value.url}, Map.merge(state, %{shortcode => value})}
      :error ->
        {:reply, {:error, :shortcode_not_found}, state}
    end
  end

  def handle_call(:debug, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, %{}}
  end

  def handle_call({:put, url, shortcode}, _from, state) do
    shortcode = shortcode || generate_unique_shortcode(state)
    case Map.fetch(state, shortcode) do
      :error ->
        record = %{
          url:           url,
          display_count: 0,
          displayed_at:  nil,
          start_date:    DateTime.now
        }

        {:reply, {:ok, shortcode}, Map.merge(state, %{shortcode => record})}
      {:ok, _} ->
        {:reply, {:error, :shortcode_already_exists}, state}
    end
  end

  # Utilities

  def generate_unique_shortcode(state, count \\ 0) do
    shortcode = Entry.generate_shortcode(count)
    case Map.fetch(state, shortcode) do
      :error ->
        shortcode
      {:ok, _} ->
        generate_unique_shortcode(state, count + 1)
    end
  end
end
