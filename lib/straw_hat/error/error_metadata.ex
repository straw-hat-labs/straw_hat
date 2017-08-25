defmodule StrawHat.Error.ErrorMetadata do
  alias StrawHat.Error.ErrorMetadata

  defstruct [:key, :value]

  def new({key, value}), do: new(key, value)

  def new(key, value) do
    %ErrorMetadata{
      key: to_string(key),
      value: to_string(value)
    }
  end
end
