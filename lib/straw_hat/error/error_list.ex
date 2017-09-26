defmodule StrawHat.Error.ErrorList do
  @moduledoc """
  Data structure that represents a list of `StrawHat.Error`.
  """

  alias StrawHat.Error.ErrorList

  @typedoc """
  - `errors`: List of `StrawHat.Error`.
  """
  @type t :: %StrawHat.Error.ErrorList{errors: [StrawHat.Error.t]}

  defstruct [errors: []]

  @doc """
  Creates a `StrawHat.Error.ErrorList`
  """
  @spec new([StrawHat.Error.t]) :: t
  def new(errors), do: %ErrorList{errors: errors}
end

defimpl Enumerable, for: StrawHat.Error.ErrorList do
  def reduce(error_list, acc, fun), do: Enumerable.reduce(error_list.errors, acc, fun)
  def member?(error_list, element), do: {:ok, Enum.member?(error_list.errors, element)}
  def count(error_list), do: {:ok, Enum.count(error_list.errors)}
end
