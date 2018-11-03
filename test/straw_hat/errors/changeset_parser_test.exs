defmodule StrawHat.ErrorChangePaserTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias StrawHat.Error.ChangesetParser

  @types %{
    pets: {:array, :string},
    title: :string,
    password: :string,
    password_confirmation: :string,
    email: :string
  }

  @default %{title: "bar"}


  @params %{
    "pets" => ["pepehands"],
    "title" => "foobar",
    "password" => "123",
    "password_confirmation" => "1234",
    "email" => "invalid.com"
  }

  defp get_changeset(params) do
    type_keys = Map.keys(@types)

    {@default, @types}
    |> cast(params, type_keys)
    |> validate_confirmation(:password)
    |> validate_length(:title, is: 9)
    |> validate_subset(:pets, ["cat", "dog", "parrot"])
  end

  test "parse/1 returns the correct error list" do
    assert %StrawHat.Error{code: "something"} =
      @params
      |> get_changeset()
      |> ChangesetParser.parse()
  end
end
