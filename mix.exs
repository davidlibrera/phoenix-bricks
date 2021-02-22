defmodule PhoenixBricks.MixProject do
  use Mix.Project

  @version "0.1.3"
  @elixir_requirements "~> 1.11"
  @source_url "https://github.com/davidlibrera/phoenix_bricks"

  def project do
    [
      app: :phoenix_bricks,
      deps: deps(),
      description: description(),
      dialyzer: [plt_file: {:no_warn, "priv/plts/dialyzer.plt"}],
      docs: docs(),
      elixir: @elixir_requirements,
      package: package(),
      start_permanent: Mix.env() == :prod,
      source_url: @source_url,
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
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Provides simple modules with common method for pure CRUD PhoenixLiveView
    applications.
    """
  end

  defp docs do
    [
      canonical: "http://hexdocs.pm/phoenix_bricks",
      extras: extras(),
      extra_section: "GUIDES",
      groups_for_extras: groups_for_extras(),
      main: "PhoenixBricks",
      name: "Phoenix Bricks",
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp extras do
    [
      "guides/introduction/Intro.md",
      "README.md",
      "LICENSE.md"
    ]
  end

  defp groups_for_extras do
    [
      "Introduction": ~r/guides\/introduction\/.?/
    ]
  end
end
