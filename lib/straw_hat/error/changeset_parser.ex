if Code.ensure_loaded?(Ecto) do
  defmodule StrawHat.Error.ChangesetParser do
    @moduledoc """
    Ecto.Changeset parser that transforms the Ecto.Changeset errors into
    list of `%StrawHat.Error{}`.
    """

    alias Ecto.Changeset
    alias StrawHat.Error

    @doc """
    Parse an `%Ecto.Changeset{}` errors into a list of `%StrawHat.Error{}`.
    """
    @since "0.4.3"
    @spec parse(Ecto.Changeset.t()) :: [StrawHat.Error.t()]
    def parse(changeset) do
      changeset
      |> Changeset.traverse_errors(&construct_error/3)
      |> Enum.to_list()
      |> Enum.flat_map(fn {_field, values} -> values end)
    end

    @since "0.4.3"
    @spec construct_error(Ecto.Changeset.t(), atom(), {String.t(), keyword()}) :: StrawHat.Error.t()
    defp construct_error(_changeset, field, {_message, opts} = error_tuple) do
      metadata =
        opts
        |> tidy_opts()
        |> Keyword.put(:field_name, field)

      error_tuple
      |> get_code()
      |> Error.new(type: "ecto_validation", metadata: metadata)
    end

    @since "0.4.3"
    @spec tidy_opts(keyword()) :: keyword()
    defp tidy_opts(opts), do: Keyword.drop(opts, [:validation, :constraint])

    @since "0.4.3"
    @spec get_code({String.t(), keyword()}) :: String.t()
    defp get_code({_message, opts}) do
      code =
        opts
        |> Enum.into(%{})
        |> code_suffix()

      "ecto.changeset." <> code
    end

    @since "0.4.3"
    @spec code_suffix(map()) :: String.t()
    defp code_suffix(%{validation: :number, kind: kind}) do
      validation_error_preffix("number." <> to_string(kind))
    end

    @since "0.4.3"
    @spec code_suffix(map()) :: String.t()
    defp code_suffix(%{validation: validation_name}) do
      validation_error_preffix(validation_name)
    end

    @since "0.4.3"
    @spec code_suffix(map()) :: String.t()
    defp code_suffix(%{constraint: constraint_name}) do
      constraint_error_preffix(constraint_name)
    end

    # Supplied when validation cannot be matched. This will also match
    # any custom errors added through
    # - Ecto.Changeset.add_error/4
    # - Ecto.Changeset.validate_change/3
    # - Ecto.Changeset.validate_change/4
    @since "0.4.3"
    @spec code_suffix(any()) :: String.t()
    defp code_suffix(_unknown), do: "unknown"

    @since "0.4.3"
    @spec validation_error_preffix(String.t() | atom()) :: String.t()
    defp validation_error_preffix(validation_name) do
      "validation." <> to_string(validation_name)
    end

    @since "0.4.3"
    @spec constraint_error_preffix(String.t() | atom()) :: String.t()
    defp constraint_error_preffix(constraint_name) do
      "constraint." <> to_string(constraint_name)
    end
  end
end
