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
  Creates a `t:StrawHat.Error.ErrorList.t/0`
  """
  @since "0.4.0"
  @spec new([StrawHat.Error.t()]) :: t
  def new(errors), do: %__MODULE__{errors: errors}
end

defimpl Enumerable, for: StrawHat.Error.ErrorList do
  def reduce(error_list, acc, fun), do: Enumerable.reduce(error_list.errors, acc, fun)
  def member?(error_list, element), do: {:ok, Enum.member?(error_list.errors, element)}
  def count(error_list), do: {:ok, Enum.count(error_list.errors)}
  def slice(_error_list), do: {:error, StrawHat.Error.ErrorList}
end
