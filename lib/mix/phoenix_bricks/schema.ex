defmodule Mix.PhoenixBricks.Schema do
  @moduledoc false

  alias Mix.PhoenixBricks.Schema

  defstruct context_app: nil,
            expanded_macro: nil,
            filter_file: nil,
            filters: nil,
            module: nil,
            query_file: nil

  def new(schema_name, filters, opts) do
    context_app = Mix.Phoenix.context_app()
    base = Mix.Phoenix.context_base(context_app)
    basename = Phoenix.Naming.underscore(schema_name)
    module = Module.concat([base, schema_name])
    filter_file = Mix.Phoenix.context_lib_path(context_app, basename <> "_filter.ex")
    query_file = Mix.Phoenix.context_lib_path(context_app, basename <> "_query.ex")
    expanded_macro = opts[:expand_macro] == true
    filters = split_filters(filters)

    %Schema{
      context_app: context_app,
      expanded_macro: expanded_macro,
      filter_file: filter_file,
      filters: filters,
      module: module,
      query_file: query_file
    }
  end

  def valid?(schema) do
    schema =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/
  end

  def split_filters(filters) do
    filters
    |> Enum.map(fn filter -> String.split(filter, ":") end)
    |> Enum.map(fn [field, type] -> {field, type} end)
  end
end
