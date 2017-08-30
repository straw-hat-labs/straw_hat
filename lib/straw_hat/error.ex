defmodule StrawHat.Error do
  alias StrawHat.Error.{ChangesetParser, ErrorList}
  alias StrawHat.Error
  alias StrawHat.Error.ErrorMetadata

  @enforce_keys [:id, :code]
  defstruct [:id, :code, :type, :metadata]

  def new(%Ecto.Changeset{} = changeset) do
    changeset
    |> ChangesetParser.parse()
    |> ErrorList.new()
  end

  def new(code, params \\ [])
  def new(code, params) do
    type = Keyword.get(params, :type, "generic")
    metadata =
      params
      |> Keyword.get(:metadata, [])
      |> ErrorMetadata.serialize()

    %Error{
      id: UUID.uuid1(),
      code: code,
      type: type,
      metadata: metadata
    }
  end
end
