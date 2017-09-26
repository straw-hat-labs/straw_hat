defmodule StrawHat.GraphQL.MutationResponse do
  @moduledoc """
  Absinthe Mutation Response utilities. Normally will be use in Absinthe resolvers.
  """

  alias StrawHat.Error
  alias StrawHat.Error.ErrorList

  @typedoc """
  - `successful`: When the mutation succeeded or not.
  - `payload`: Data of the mutation payload.
  - `errors`: List of `StrawHat.Error`.
  """
  @type mutation_response :: %{successful: boolean,
                               payload: any,
                               errors: [StrawHat.Error.t]}

  @doc """
  Returns a failed mutation response map.
  """
  @spec failed(Ecto.Changeset.t) :: {:ok, mutation_response}
  def failed(%Ecto.Changeset{} = changeset) do
    changeset
    |> Error.new()
    |> failed()
  end
  @spec failed(StrawHat.Error.t) :: {:ok, mutation_response}
  def failed(%Error{} = error) do
    [error]
    |> ErrorList.new()
    |> failed()
  end
  @spec failed(StrawHat.Error.ErrorList.t) :: {:ok, mutation_response}
  def failed(%ErrorList{} = error_list) do
    response = %{
      successful: false,
      errors: error_list.errors}

    respond(response)
  end
  @spec failed(any) :: no_return
  def failed(_), do: raise ArgumentError

  @doc """
  Returns a succeeded mutation response map.
  """
  @spec succeeded(any) :: {:ok, mutation_response}
  def succeeded(payload) do
    response = %{
      successful: true,
      payload: payload}

    respond(response)
  end

  defp respond(payload), do: {:ok, payload}
end
