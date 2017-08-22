defmodule StrawHat.ErrorList do
  alias StrawHat.Error
  alias StrawHat.Error.ChangesetParser

  defstruct [errors: []]

  def new(%Ecto.Changeset{} = changeset) do
    ChangesetParser.parse(changeset)
  end
end
