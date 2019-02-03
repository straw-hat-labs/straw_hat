if Code.ensure_loaded?(Ecto) do
  defmodule StrawHat.Ecto.Changeset do
    @moduledoc """
    Some utils functions around Ecto.Changeset
    """

    @doc """
    A helper that transform changeset errors to a map of messages.
    """
    @spec transform_to_map(Ecto.Changeset.t()) :: map()
    def transform_to_map(%Ecto.Changeset{} = changeset) do
      Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
        Enum.reduce(opts, message, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
    end
  end
end
