defmodule Shorty.Mixfile do
  use Mix.Project

  def project do
    [app: :shorty,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["test.watch": :test, "coveralls": :test, "coveralls.detail": :test, "coveralls.html": :test]
   ]
  end

  def application do
    [applications: [:tzdata, :logger, :cowboy, :plug, :poison],
     mod: {Shorty, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.1.4"},
      {:timex, "~> 2.1.4"},
      {:poison, "~> 2.1.0"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.2", only: [:test, :dev]},
      {:excoveralls, "~> 0.5", only: :test},
      {:mock, "~> 0.1.1", only: :test}
    ]
  end
end
