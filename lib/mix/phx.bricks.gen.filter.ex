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

    build(args)
    |> copy_new_files()
  end

  def build(args) do
    {opts, parsed} = OptionParser.parse!(args, strict: @switches)

    [schema_name | filters] = validate_args!(parsed)

    Schema.new(schema_name, filters, opts)
  end

  defp copy_new_files(%Schema{filter_file: file, expanded_macro: false} = schema) do
    [{:eex, "filter.ex", file}]
    |> copy_files(schema: schema)
  end

  defp copy_new_files(%Schema{filter_file: file, expanded_macro: true} = schema) do
    [{:eex, "filter_expanded.ex", file}]
    |> copy_files(schema: schema)
  end

  defp copy_files(files, binding) do
    paths = generator_paths()
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.bricks.gen.filter", binding, files)
  end

  defp validate_args!([schema_name | _filters] = args) do
    if Schema.valid?(schema_name) do
      args
    else
      raise_with_help("Schema name not valid")
    end
  end

  defp validate_args!(_) do
    raise_with_help("Invalid arguments")
  end

  @spec raise_with_help(String.t()) :: no_return()
  def raise_with_help(msg) do
    Mix.raise("""
    #{msg}
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
