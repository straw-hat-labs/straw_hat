defmodule StrawHat.GraphQL.Resolver.MetadataResolver do
  def key(%{key: key}, _, %{adapter: adapter}) do
    {:ok, adapter.to_external_name(key, :field)}
  end

  def value(%{key: "field_name", value: value}, _, %{adapter: adapter}) do
    {:ok, adapter.to_external_name(value, :field)}
  end
  def value(%{value: value}, _, _), do: {:ok, value}
end
