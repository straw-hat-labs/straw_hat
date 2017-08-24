defmodule StrawHat.GraphQL.Scalars do
  use Absinthe.Schema.Notation

  scalar :json, name: "JSON" do
    parse fn %{value: value} ->
      case Poison.decode(value) do
        {:ok, result} -> {:ok, result}
        _ -> :error
      end
    end
    serialize &Poison.encode!/1
  end
end
