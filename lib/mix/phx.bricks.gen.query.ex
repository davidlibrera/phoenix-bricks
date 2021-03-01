defmodule Mix.Tasks.Phx.Bricks.Gen.Query do
  use Mix.Task

  alias Mix.PhoenixBricks.Schema

  @shortdoc "Generates schema filter logic for a resource"

  @moduledoc """
  Generates a Query module around an Ecto
  """

  @switches [expand_macro: :boolean]

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix phx.bricks.gen.query must be invoked from within your *_web application root directory"
      )
    end

    build(args)
    |> copy_new_files()
  end

  def build(args) do
    {opts, parsed} = OptionParser.parse!(args, strict: @switches)

    [schema_name] = validate_args!(parsed)

    Schema.new(schema_name, opts)
  end

  defp copy_new_files(%Schema{query_file: file, expanded_macro: false} = schema) do
    [{:eex, "query.ex", file}]
    |> copy_files(schema: schema)
  end

  defp copy_new_files(%Schema{query_file: file, expanded_macro: true} = schema) do
    [{:eex, "query_expanded.ex", file}]
    |> copy_files(schema: schema)
  end

  defp copy_files(files, binding) do
    paths = generator_paths()
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.bricks.gen.query", binding, files)
  end

  defp validate_args!([_] = args), do: args

  defp validate_args!(_) do
    Mix.raise("""
    Invalid arguments.
    mix phx.bricks.gen.query expects a schema module name.
    For example:
    mix phx.bricks.gen.query Product
    The query server as a module that improves an ecto query with additional
    query components.
    """)
  end

  defp generator_paths do
    [".", :phoenix_bricks]
  end
end
