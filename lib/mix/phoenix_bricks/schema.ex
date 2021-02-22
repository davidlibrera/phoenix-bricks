defmodule Mix.PhoenixBricks.Schema do
  @moduledoc false

  alias Mix.PhoenixBricks.Schema

  defstruct context_app: nil,
            file: nil,
            module: nil

  def new(schema_name) do
    context_app = Mix.Phoenix.context_app()
    base = Mix.Phoenix.context_base(context_app)
    basename = Phoenix.Naming.underscore(schema_name)
    module = Module.concat([base, schema_name])
    file = Mix.Phoenix.context_lib_path(context_app, basename <> "_filter.ex")

    %Schema{
      context_app: context_app,
      module: module,
      file: file
    }
  end
end
