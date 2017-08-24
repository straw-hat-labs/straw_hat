defmodule StrawHat.Error.ErrorList do
  alias StrawHat.Error.ChangesetParser
  alias StrawHat.Error.ErrorList
  alias StrawHat.Error

  defstruct [errors: []]

  def new(%Ecto.Changeset{} = changeset) do
    changeset
    |> ChangesetParser.parse()
    |> new()
  end
  def new(%Error{} = error) do
    [error] |> new()
  end
  def new(errors) do
    %ErrorList{errors: errors}
  end
end
