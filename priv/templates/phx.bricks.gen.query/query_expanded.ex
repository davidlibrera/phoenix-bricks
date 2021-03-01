defmodule <%= inspect schema.module %>Query do
  @moduledoc false

  def starting_scope do
    <%= inspect schema.module %>
  end

  def scope(starting_scope, scopes) do
    scopes
    |> Enum.reduce(starting_scope, fn scope, query ->
      apply_scope(query, scope)
    end)
  end

  def scope(scopes) do
    starting_scope()
    |> scope(scopes)
  end

  def scope do
    starting_scope()
  end

  defp apply_scope(query, {column, {:eq, value}}) do
    where(query, [q], field(q, ^column) == ^value)
  end

  defp apply_scope(query, {column, {:neq, value}}) do
    where(query, [q], field(q, ^column) != ^value)
  end

  defp apply_scope(query, {column, {:lte, value}}) do
    where(query, [q], field(q, ^column) <= ^value)
  end

  defp apply_scope(query, {column, {:lt, value}}) do
    where(query, [q], field(q, ^column) < ^value)
  end

  defp apply_scope(query, {column, {:gte, value}}) do
    where(query, [q], field(q, ^column) >= ^value)
  end

  defp apply_scope(query, {column, {:gt, value}}) do
    where(query, [q], field(q, ^column) > ^value)
  end

  defp apply_scope(query, {column, {:matches, value}}) do
    where(query, [q], ilike(field(q, ^column), ^value))
  end
end
