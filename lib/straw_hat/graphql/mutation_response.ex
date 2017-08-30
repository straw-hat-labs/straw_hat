defmodule StrawHat.GraphQL.MutationResponse do
  alias StrawHat.Error
  alias StrawHat.Error.ErrorList

  def failed(%Ecto.Changeset{} = changeset) do
    changeset
    |> Error.new()
    |> failed()
  end
  def failed(%Error{} = error) do
    [error]
    |> ErrorList.new()
    |> failed()
  end
  def failed(%ErrorList{} = error_list) do
    %{successful: false,
      errors: error_list.errors}
  end
  def failed(_), do: raise ArgumentError

  def succeeded(payload) do
    %{successful: true,
      payload: payload}
  end
end
