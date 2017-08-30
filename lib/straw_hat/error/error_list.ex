defmodule StrawHat.Error.ErrorList do
  alias StrawHat.Error.ErrorList

  defstruct [errors: []]

  def new(errors) when is_list(errors) do
    Enum.map(errors, fn(%{code: code, id: id, metadata: metadata, message: message}) ->
      %{message: message, code: code, id: id, metadata: metadata}
    end)
  end
  def new(errors), do: %ErrorList{errors: errors}
end
