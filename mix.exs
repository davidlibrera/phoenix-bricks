defmodule PhoenixBricks.MixProject do
  use Mix.Project

  @version "0.3.1"
  @elixir_requirements "~> 1.8"
  @source_url "https://github.com/davidlibrera/phoenix_bricks"

  def project do
    [
      app: :phoenix_bricks,
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: @elixir_requirements,
      package: package(),
      preferred_cli_env: [coveralls: :test, "coveralls.circle": :test],
      start_permanent: Mix.env() == :prod,
      source_url: @source_url,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["David Librera"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/davidlibrera/phoenix_bricks"},
      files: ~w(lib LICENSE.md mix.exs README.md .formatter.exs)
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.4"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:phoenix, "~> 1.5"}
    ]
  end

  defp description do
    """
    Provides simple modules with common method for pure CRUD PhoenixLiveView
    applications.
    """
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix],
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      name: "Phoenix Bricks",
      main: "PhoenixBricks",
      canonical: "http://hexdocs.pm/phoenix_bricks",
      source_url: @source_url,
      extras: ["README.md", "LICENSE.md"]
    ]
  end
end
