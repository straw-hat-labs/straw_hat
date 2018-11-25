defmodule StrawHat.Error.ErrorList do
  @moduledoc """
  Data structure that represents a list of `t:StrawHat.Error.t/0`.
  """

  @typedoc """
  List of Errors.

  - `errors`: List of `t:StrawHat.Error.t/0`.
  """
  @type t :: %__MODULE__{errors: [StrawHat.Error.t()]}

  defstruct errors: []

  @doc """
  Creates an `t:StrawHat.Error.ErrorList.t/0`
  """
  @since "0.4.0"
  @spec new([StrawHat.Error.t()]) :: t
  def new(errors), do: %__MODULE__{errors: errors}
end

defimpl Enumerable, for: StrawHat.Error.ErrorList do
  @since "0.4.0"
  def reduce(error_list, acc, fun), do: Enumerable.reduce(error_list.errors, acc, fun)

  @since "0.4.0"
  def member?(error_list, element), do: {:ok, Enum.member?(error_list.errors, element)}

  @since "0.4.0"
  def count(error_list), do: {:ok, Enum.count(error_list.errors)}

  @since "0.4.0"
  def slice(_error_list), do: {:error, StrawHat.Error.ErrorList}
end
