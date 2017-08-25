defmodule StrawHat.Error.ErrorList do
  alias StrawHat.Error.ErrorList

  defstruct [errors: []]

  def new(errors), do: %ErrorList{errors: errors}
end
