defmodule StrawHat.Error.ChangesetParser do
  alias Ecto.Changeset
  alias StrawHat.Error

  def parse(changeset) do
    changeset
    |> Changeset.traverse_errors(&construct_error/3)
    |> Enum.to_list()
    |> Enum.flat_map(fn({_field, values}) -> values end)
  end

  defp construct_error(_changeset, field, {_message, opts} = error_tuple) do
    metadata =
      opts
      |> tidy_opts()
      |> Keyword.put(:field_name, field)

    error_tuple
    |> get_code()
    |> Error.new([type: "ecto_validation", metadata: metadata])
  end

  defp tidy_opts(opts), do: Keyword.drop(opts, [:validation, :constraint])

  defp get_code({message, opts}) do
    code =
      opts
      |> Enum.into(%{message: message})
      |> do_get_code()

    "ecto.changeset." <> code
  end

  # @TODO: all this is wrong, waiting for PR to be merged
  defp do_get_code(%{validation: :number, message: message}) do
    cond do
      # Ecto.Changeset.validate_number/3 when the :less_than_or_equal_to option
      # fails validation
      String.contains?(message, "less than or equal to") ->
        "validation.number.less_than_or_equal_to"

      # Ecto.Changeset.validate_number/3 when the :greater_than_or_equal_to
      # option fails validation
      String.contains?(message, "greater than or equal to") ->
        "validation.number.greater_than_or_equal_to"

      # Ecto.Changeset.validate_number/3 when the :less_than option
      # fails validation
      String.contains?(message, "less than") ->
        "validation.number.less_than"

      # Ecto.Changeset.validate_number/3 when the :greater_than option
      # fails validation
      String.contains?(message, "greater than") ->
        "validation.number.greater_than"

      # Ecto.Changeset.validate_number/3 when the :equal_to option
      # fails validation
      String.contains?(message, "equal to") ->
        "validation.number.equal_to"

      true -> :unknown
    end
  end

  # @TODO: this is wrong, waiting for PR to be merged
  # - Ecto.Changeset.assoc_constraint/3
  # - Ecto.Changeset.cast_assoc/3
  # - Ecto.Changeset.put_assoc/3
  # - Ecto.Changeset.cast_embed/3
  # - Ecto.Changeset.put_embed/3
  defp do_get_code(%{message: "is invalid", type: _}),
    do: get_constraint_code("assoc")

  # Ecto.Changeset.unique_constraint/3
  defp do_get_code(%{message: "has already been taken"}),
    do: get_constraint_code("unique")

  # Ecto.Changeset.foreign_key_constraint/3
  defp do_get_code(%{message: "does not exist"}),
    do: get_constraint_code("foreign")

  # Ecto.Changeset.no_assoc_constraint/3
  defp do_get_code(%{message: "is still associated with this entry"}),
    do: get_constraint_code("no_assoc")

  defp do_get_code(%{validation: validation_name}),
    do: get_validation_code(validation_name)

  defp do_get_code(%{constraint: constraint_name}),
    do: get_constraint_code(constraint_name)

  # Supplied when validation cannot be matched. This will also match
  # any custom errors added through
  # - Ecto.Changeset.add_error/4
  # - Ecto.Changeset.validate_change/3
  # - Ecto.Changeset.validate_change/4
  defp do_get_code(_unknown), do: "unknown"

  defp get_validation_code(validation_name), do: "validation." <> to_string(validation_name)

  defp get_constraint_code(constraint_name), do: "constraint." <> to_string(constraint_name)
end
