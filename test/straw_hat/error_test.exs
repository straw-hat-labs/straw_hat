defmodule StrawHatTest.ErrorTest do
  use ExUnit.Case
  import Ecto.Changeset

  doctest StrawHat.Error

  @types %{
    title: :string,
    terms_of_service: :boolean,
    password: :string,
    password_confirmation: :string,
    name: :string,
    email: :string,
    age: :integer,
    missing_field: :boolean
  }

  @default %{title: "bar"}

  @params %{
    "title" => "foobar",
    "terms_of_service" => false,
    "password" => "123",
    "password_confirmation" => "1234",
    "name" => "admin",
    "email" => "invalid.com",
    "age" => 100
  }

  defp get_changeset(params) do
    type_keys = Map.keys(@types)

    {@default, @types}
    |> cast(params, type_keys)
    |> validate_acceptance(:terms_of_service)
    |> validate_change(:title, fn :title, title ->
      if title == "foobar" do
        [title: {"cannot be foo", [validation: :cant_be, value: "foobar"]}]
      else
        []
      end
    end)
    |> validate_confirmation(:password)
    |> validate_exclusion(:name, ~w(admin superadmin))
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:age, 0..99)
    |> validate_length(:title, is: 9)
    |> validate_number(:age, less_than: 99)
    |> validate_required(:missing_field)
  end

  describe "changetset" do
    test "get list of errors" do
      error_list =
        @params
        |> get_changeset()
        |> StrawHat.Error.new()
        |> IO.inspect()

      assert is_list(error_list)
    end
  end
end
