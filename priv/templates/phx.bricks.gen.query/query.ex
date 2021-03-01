defmodule <%= inspect schema.module %>Query do
  @moduledoc false

  use PhoenixBricks.Scopes, schema: <%= inspect schema.module %>
end
