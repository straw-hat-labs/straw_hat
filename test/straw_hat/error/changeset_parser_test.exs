defmodule StrawHat.Error.ChangesetParserTest do
  use ExUnit.Case, async: true
  alias Ecto.Changeset
  alias StrawHat.Error.ChangesetParser

  defmodule Post do
    use Ecto.Schema

    schema "posts" do
      field(:title, :string, default: "")
      field(:upvotes, :integer, default: 0)
    end
  end

  defp changeset(schema \\ %Post{}, params) do
    Changeset.cast(schema, params, ~w(id title upvotes)a)
  end

  test "parsing Ecto.Changeset errors" do
    errors =
      %{"upvotes" => -1}
      |> changeset()
      |> Changeset.validate_required(:title)
      |> Changeset.validate_number(:upvotes, greater_than: 0)
      |> Changeset.add_error(:title, "empty",
        constraint: :unique,
        constraint_name: "custom_foo_index"
      )
      |> ChangesetParser.parse()

    assert Enum.at(errors, 0).code == "ecto.changeset.constraint.unique"
    assert Enum.at(errors, 1).code == "ecto.changeset.validation.required"
    assert Enum.at(errors, 2).code == "ecto.changeset.validation.number.greater_than"
  end
end
