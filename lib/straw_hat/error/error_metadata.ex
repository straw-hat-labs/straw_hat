defmodule StrawHat.Error.ErrorMetadata do
  @moduledoc """
  Metadata used on `%StrawHat.Error{}`. It is a representation of key value
  pair into `%StrawHat.Error.ErrorMetadata{}`. Mostly used throw `StrawHat.Error`.
  """

  alias StrawHat.Error.ErrorMetadata

  @typedoc """
  - `key`: Key of the metadata.
  - `value`: Value of the metadata.
  """
  @type t :: %StrawHat.Error.ErrorMetadata{key: String.t, value: String.t}

  @enforce_keys [:key, :value]
  defstruct [:key, :value]

  @doc """
  Creates an `%ErrorMetadata{}`.
  """
  @spec new({String.t | atom, any}) :: t
  def new({key, value} = _value_tuple), do: new(key, value)

  @doc """
  Creates an `%ErrorMetadata{}`.
  """
  @spec new(atom | String.t, any) :: t
  def new(key, value) do
    %ErrorMetadata{
      key: to_string(key),
      value: to_string(value)
    }
  end

  def serialize(metadata), do: Enum.map(metadata, fn({key, value}) -> new(key, value) end)
end
