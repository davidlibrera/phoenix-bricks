defmodule Mix.Tasks.Phx.Bricks.Gen.Filter do
  use Mix.Task

  alias Mix.PhoenixBricks.Schema

  @shortdoc "Generates params filter logic for a resource"

  @moduledoc """
  Generates a Filter schema around an Ecto schema
  """

  @switches [expand_macro: :boolean]

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix phx.bricks.gen.filter must be invoked from within your *_web application root directory"
      )
    end

    schema = build(args)
    paths = generator_paths()

    schema
    |> copy_new_files(paths, schema: schema)
  end

  def build(args) do
    {_opts, parsed} = OptionParser.parse!(args, strict: @switches)

    [schema_name] = validate_args!(parsed)

    Schema.new(schema_name)
  end

  defp copy_new_files(%Schema{file: file}, paths, binding) do
    files = [{:eex, "filter.ex", file}]
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.bricks.gen.filter", binding, files)
  end

  defp validate_args!([_] = args), do: args

  defp validate_args!(_) do
    Mix.raise("""
    Invalid arguments.
    mix phx.bricks.gen.filter expects a schema module name.
    For example:
    mix phx.bricks.gen.filter Product
    The filter serves as schema for filter form and provides a keyword list of
    filters parsed from params.
    """)
  end

  defp generator_paths do
    [".", :phoenix_bricks]
  end
end
