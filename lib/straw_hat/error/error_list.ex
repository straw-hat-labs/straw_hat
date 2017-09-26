defmodule StrawHat.Error.ErrorList do
  @moduledoc """
  Data structure that represents a list of `StrawHat.Error`.
  """

  alias StrawHat.Error.ErrorList

  @typedoc """
  - `errors`: List of `StrawHat.Error`.
  """
  @type t :: %StrawHat.Error.ErrorList{errors: list(StrawHat.Error.t)}

  defstruct [errors: []]

  @doc """
  Creates a `StrawHat.Error.ErrorList`
  """
  @spec new(list(StrawHat.Error.t)) :: t
  def new(errors), do: %ErrorList{errors: errors}
end
