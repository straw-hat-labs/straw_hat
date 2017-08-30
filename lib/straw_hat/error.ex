defmodule StrawHat.Error do
  alias StrawHat.Error.{ChangesetParser, ErrorList}
  alias StrawHat.Error

  @enforce_keys [:id, :code]
  defstruct [:id, :code, :message, :metadata]

  def new(%Ecto.Changeset{} = changeset) do
    changeset
    |> ChangesetParser.parse()
    |> ErrorList.new()
  end
  def new(%StrawHat.Error{} = error),
    do: error

  def new(code, params \\ [])
  def new(code, params) do
    message = Keyword.get(params, :message, "error")
    metadata = Keyword.get(params, :metadata, [])

    %Error{
      id: UUID.uuid1(),
      code: code,
      message: message,
      metadata: serialize(metadata)
    }
  end

  def serialize(metadata),
    do: Enum.map(metadata, fn(map) -> type_of(map) end)

  def type_of(%StrawHat.Error.ErrorMetadata{key: key, value: value}),
    do: tuple(key, value)
  def type_of({key, value}),
    do: tuple(key, value)

  def tuple(key, value),
    do: %{key: key, value: value}
end
