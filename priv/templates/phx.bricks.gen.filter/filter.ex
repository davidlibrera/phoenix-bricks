defmodule <%= inspect schema.module %>Filter do
  @moduledoc false

  use PhoenixBricks.Filter,
    filters: [
<%= schema.filters |> Enum.map(fn {name, type} -> "      #{name}: :#{type}" end) |> Enum.join(",\n") %>
    ]
end
