defmodule <%= inspect schema.module %>Filter do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
<%= schema.filters |> Enum.map(fn {name, type} -> "    field :#{name}, :#{type}" end) |> Enum.join("\n") %>
  end

  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [<%= schema.filters |> Enum.map(fn {name, _} -> ":#{name}" end) |> Enum.join(", ") %>])
  end

  def convert_params_to_scopes(params) do
    filters = Map.get(params, "filters", %{})
    filter_changeset = changeset(%<%= inspect schema.module %>Filter{}, filters)

    filter_changeset.changes
    |> Enum.map(fn {name, value} -> {name, value} end)
  end
end
