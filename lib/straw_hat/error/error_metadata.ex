defmodule StrawHat.Error.ErrorMetadata do
  @moduledoc """
  Metadata used on `t:StrawHat.Error.t/0`. It is a representation of key value
  pair into `t:StrawHat.Error.ErrorMetadata.t/0`. Most likely used throw
  `StrawHat.Error`.
  """

  @typedoc """
  - `key`: Key of the metadata.
  - `value`: Value of the metadata.
  """
  @type t :: %__MODULE__{key: String.t(), value: String.t()}

  @enforce_keys [:key, :value]
  defstruct [:key, :value]

  @doc """
  Creates a `t:StrawHat.Error.ErrorMetadata.t/0` from a tuple.
  """
  @spec new({String.t() | atom, any}) :: t
  def new({key, value} = _value_tuple), do: new(key, value)

  @doc """
  Creates a `t:StrawHat.Error.ErrorMetadata.t/0`.
  """
  @spec new(atom | String.t(), any) :: t
  def new(key, value) do
    %__MODULE__{key: to_string(key), value: to_string(value)}
  end

  @doc """
  Serialize a Keyword list into a list of `t:StrawHat.Error.ErrorMetadata.t/0`.
  """
  @spec serialize(Keyword.t()) :: [t]
  def serialize(metadata), do: Enum.map(metadata, fn {key, value} -> new(key, value) end)
end
