defmodule StrawHat.ErrorChangePaserTests do
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

  describe "parse/1" do
    test "with validate_required/2" do
      error =
        %{}
        |> changeset()
        |> Changeset.validate_required(:title)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.required"
    end

    test "with validate_number/3" do
      error =
        %{"upvotes" => -1}
        |> changeset()
        |> Changeset.validate_number(:upvotes, greater_than: 0)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.number.greater_than"
    end

    test "with mocked unique constraint" do
      error =
        %{}
        |> changeset()
        |> Changeset.add_error(:title, "empty",
          constraint: :unique,
          constraint_name: "custom_foo_index"
        )
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.constraint.unique"
    end
  end
end
