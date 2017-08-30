defmodule StrawHat.Error.ErrorMetadata do
  alias StrawHat.Error.ErrorMetadata

  defstruct [:key, :value]

  def new({key, value} = _value_tuple), do: new(key, value)

  def new(key, value) do
    %ErrorMetadata{
      key: to_string(key),
      value: to_string(value)
    }
  end

  def serialize(metadata), do: Enum.map(metadata, fn({key, value}) -> new(key, value) end)
end
