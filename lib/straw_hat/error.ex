defmodule StrawHat.Error do
  alias StrawHat.Error

  defstruct [id: "", code: "", metadata: []]

  def new(%Ecto.Changeset{} = changeset), do: StrawHat.ErrorList.new(changeset)

  def new(code, metadata \\ [])
  def new(code, metadata) do
    %Error{
      id: UUID.uuid1(),
      code: code,
      metadata: metadata
    }
  end
end
