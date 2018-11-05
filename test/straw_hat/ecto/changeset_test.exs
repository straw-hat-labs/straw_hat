defmodule StrawHat.EctoChangesetTest do
  use ExUnit.Case, async: true
  import Ecto.Changeset

  alias StrawHat.Ecto.Changeset, as: StrawHatChangeset

  @types %{
    title: :string,
    password: :string,
    password_confirmation: :string,
    email: :string
  }

  @default %{title: "bar"}

  @params %{
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
  end

  test "transform_to_map/1 transforms the Ecto.Changeset into a map" do
    error_list =
      @params
      |> get_changeset()
      |> Ecto.Changeset.add_error(:title, "random", additional: "info")

    assert %{
             password_confirmation: ["does not match confirmation"],
             title: ["random", "should be 9 character(s)"]
           } = StrawHatChangeset.transform_to_map(error_list)
  end
end
