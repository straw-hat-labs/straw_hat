defmodule StrawHat.ErrorTests do
  use ExUnit.Case, async: true
  import Ecto.Changeset
  doctest StrawHat.Error

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

  test "new/2 creates an error" do
    assert %StrawHat.Error{code: "something"} = StrawHat.Error.new("something")
  end

  test "new/1 gets the list of errors from an Ecto.Changeset" do
    error_list =
      @params
      |> get_changeset()
      |> StrawHat.Error.new()

    error_list_codes = Enum.map(error_list, fn error -> error.code end)

    assert %StrawHat.Error.ErrorList{} = error_list

    assert error_list_codes == [
             "ecto.changeset.validation.confirmation",
             "ecto.changeset.validation.length"
           ]
  end
end
