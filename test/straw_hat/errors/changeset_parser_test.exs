defmodule StrawHat.ErrorChangePaserTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias StrawHat.Error.ChangesetParser

  defmodule Post do
    use Ecto.Schema

    schema "posts" do
      field :token, :integer, primary_key: true
      field :title, :string, default: ""
      field :body
      field :uuid, :binary_id
      field :color, :binary
      field :decimal, :decimal
      field :upvotes, :integer, default: 0
      field :topics, {:array, :string}
      field :virtual, :string, virtual: true
      field :published_at, :naive_datetime
      field :source, :map
      field :permalink, :string, source: :url
      belongs_to :category, Ecto.ChangesetTest.Category, source: :cat_id
      has_many :comments, Ecto.ChangesetTest.Comment, on_replace: :delete
      has_one :comment, Ecto.ChangesetTest.Comment
    end
  end


  defp changeset(schema \\ %Post{}, params) do
    cast(schema, params, ~w(id token title body upvotes decimal color topics virtual)a)
  end

  describe "parse/1" do
    test "with validate_required/2" do
      error =
        %{}
        |> changeset()
        |> validate_required(:title)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.required"
    end

    test "with validate_format/3" do
      error =
        %{"title" => "foobar"}
        |> changeset()
        |> validate_format(:title, ~r/@/)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.format"
    end

    test "with validate_inclusion/3" do
      error =
        %{"title" => "hello"}
        |> changeset()
        |> validate_inclusion(:title, ~w(world))
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.inclusion"
    end

    test "with validate_subset/3" do
      error =
        %{"topics" => ["cat", "laptop"]}
        |> changeset()
        |> validate_subset(:topics, ~w(cat dog))
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.subset"
    end

    test "with validate_exclusion/3" do
      error =
        %{"title" => "world"}
        |> changeset()
        |> validate_exclusion(:title, ~w(world))
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.exclusion"
    end

    test "with validate_length/3" do
      error =
        %{"title" => "world"}
        |> changeset()
        |> validate_length(:title, min: 6)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.length"
    end

    test "with validate_number/3" do
      error =
        %{"upvotes" => -1}
        |> changeset()
        |> validate_number(:upvotes, greater_than: 0)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.number.greater_than"
    end

    test "with validate_confirmation/3" do
      error =
        %{"title" => "world", "title_confirmation" => nil}
        |> changeset()
        |> validate_confirmation(:title)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.confirmation"
    end

    test "with validate_acceptance/3" do
      error =
        %{"terms_of_service" => "other"}
        |> changeset()
        |> validate_acceptance(:terms_of_service)
        |> ChangesetParser.parse()
        |> List.first()

      assert error.code == "ecto.changeset.validation.acceptance"
    end
  end
end
