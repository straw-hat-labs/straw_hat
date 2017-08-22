defmodule StrawHat.Error.ChangesetParser do
  alias StrawHat.Error

  def parse(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&construct_error/3)
    |> Enum.to_list()
    |> Enum.flat_map(fn({_field, values}) -> values end)
  end

  defp construct_error(_changeset, field, {_message, opts} = error_tuple) do
    metadata =
      opts
      |> tidy_opts()
      |> Keyword.merge([field: field])

    error_tuple
    |> get_code()
    |> Error.new(metadata)
  end

  defp tidy_opts(opts) do
    Keyword.drop(opts, [:validation, :max, :is, :min, :code])
  end

  defp get_code({message, opts}) do
    code =
      opts
      |> Enum.into(%{message: message})
      |> do_get_code()
      |> Atom.to_string()

    "ecto.validation." <> code
  end

  # Ecto.Changeset.validate_length/3 when the :is option fails validation
  defp do_get_code(%{validation: :length, is: _}), do: :length_is

  # Ecto.Changeset.validate_length/3 when the :min option fails validation
  defp do_get_code(%{validation: :length, min: _}), do: :length_min

  # Ecto.Changeset.validate_length/3 when the :max option fails validation
  defp do_get_code(%{validation: :length, max: _}), do: :length_max

  defp do_get_code(%{validation: :number, message: message}) do
    cond do
      # Ecto.Changeset.validate_length/3 when the :less_than_or_equal_to option fails validation
      String.contains?(message, "less than or equal to") -> :number_less_than_or_equal_to

      # Ecto.Changeset.validate_length/3 when the :greater_than_or_equal_to option fails validation
      String.contains?(message, "greater than or equal to") -> :number_greater_than_or_equal_to

      # Ecto.Changeset.validate_length/3 when the :less_than option fails validation
      String.contains?(message, "less than") -> :number_less_than

      # Ecto.Changeset.validate_length/3 when the :greater_than option fails validation
      String.contains?(message, "greater than") -> :number_greater_than

      # Ecto.Changeset.validate_length/3 when the :equal_to option fails validation
      String.contains?(message, "equal to") -> :number_equal_to

      true -> :unknown
    end
  end

  # - Ecto.Changeset.assoc_constraint/3
  # - Ecto.Changeset.cast_assoc/3
  # - Ecto.Changeset.put_assoc/3
  # - Ecto.Changeset.cast_embed/3
  # - Ecto.Changeset.put_embed/3
  defp do_get_code(%{message: "is invalid", type: _}), do: :association

  # Ecto.Changeset.unique_constraint/3
  defp do_get_code(%{message: "has already been taken"}), do: :unique

  # Ecto.Changeset.foreign_key_constraint/3
  defp do_get_code(%{message: "does not exist"}), do: :foreign

  # Ecto.Changeset.no_assoc_constraint/3
  defp do_get_code(%{message: "is still associated with this entry"}), do: :no_assoc

  defp do_get_code(%{validation: validation_name})
    when is_atom(validation_name), do: validation_name

  # Supplied when validation cannot be matched. This will also match
  # any custom errors added through
  # - Ecto.Changeset.add_error/4
  # - Ecto.Changeset.validate_change/3
  # - Ecto.Changeset.validate_change/4
  defp do_get_code(_unknown), do: :unknown
end
