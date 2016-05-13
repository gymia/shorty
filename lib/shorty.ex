defmodule Shorty do
  use Application

  alias Shorty.Repo
  alias Shorty.Router
  alias Plug.Adapters.Cowboy

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [worker(Repo, [])]

    if Application.get_env(:shorty, :serve_endpoints) do
      children = children ++ [Cowboy.child_spec(:http, Router, [], port: 4000)]
    end

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shorty.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
