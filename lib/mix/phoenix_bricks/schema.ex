defmodule Mix.PhoenixBricks.Schema do
  @moduledoc false

  alias Mix.PhoenixBricks.Schema

  defstruct context_app: nil,
            expanded_macro: nil,
            filter_file: nil,
            module: nil,
            query_file: nil

  def new(schema_name, opts) do
    context_app = Mix.Phoenix.context_app()
    base = Mix.Phoenix.context_base(context_app)
    basename = Phoenix.Naming.underscore(schema_name)
    module = Module.concat([base, schema_name])
    filter_file = Mix.Phoenix.context_lib_path(context_app, basename <> "_filter.ex")
    query_file = Mix.Phoenix.context_lib_path(context_app, basename <> "_query.ex")
    expanded_macro = opts[:expand_macro] == true

    %Schema{
      context_app: context_app,
      expanded_macro: expanded_macro,
      filter_file: filter_file,
      module: module,
      query_file: query_file
    }
  end
end
