defmodule StrawHat.Utils.Map do
  @moduledoc """
  Functions for transforming maps, keys and values.
  """

  defmodule AtomizeKeyError do
    @type t :: %__MODULE__{key: any}

    defexception [:key]

    @since "0.4.0"
    @spec message(%{key: String.t()}) :: String.t()
    def message(%{key: key}) do
      "\"#{key}\" binary hasn't been used on the system as an atom before"
    end
  end

  @doc ~S"""
  Recursively traverse a map and invoke a function for each key/
  value pair that transforms the map.

  ## Arguments

  * `map` is any `Map.t`

  * `function` is a function or function reference that
    is called for each key/value pair of the provided map

  ## Returns

  * The `map` transformed by the recursive application of
    `function`

  ## Examples

      iex> map = %{a: "a", b: %{c: "c"}}
      iex> StrawHat.Utils.Map.deep_map map, fn {k, v} ->
      ...>   {k, String.upcase(v)}
      ...> end
      %{a: "A", b: %{c: "C"}}

  """
  @since "0.4.0"
  @spec deep_map(Map.t(), function :: function()) :: Map.t()
  # Don't deep map structs since they have atom keys anyway and they
  # also don't support enumerable
  def deep_map(%{__struct__: _any} = map, _function) do
    map
  end

  @since "0.4.0"
  def deep_map(map, function) when is_map(map) do
    Enum.into(map, %{}, fn
      {k, v} when is_map(v) or is_list(v) ->
        {k, deep_map(v, function)}

      {k, v} ->
        function.({k, v})
    end)
  end

  @since "0.4.0"
  def deep_map([head | rest], fun) do
    [deep_map(head, fun) | deep_map(rest, fun)]
  end

  @since "0.4.0"
  def deep_map(nil, _fun) do
    nil
  end

  @since "0.4.0"
  def deep_map(value, fun) do
    fun.(value)
  end

  @doc """
  Recursively traverse a map and invoke a function for each key
  and a function for each value that transform the map.

  * `map` is any `Map.t`

  * `key_function` is a function or function reference that
    is called for each key of the provided map and any keys
    of any submaps

  * `value_function` is a function or function reference that
    is called for each value of the provided map and any values
    of any submaps

  Returns:

  * The `map` transformed by the recursive application of `key_function`
    and `value_function`
  """
  @since "0.4.0"
  @spec deep_map(Map.t(), key_function :: function(), value_function :: function()) :: Map.t()
  def deep_map(map, key_function, value_function)
  @since "0.4.0"
  def deep_map(%{__struct__: _any} = map, _key_function, _value_function) do
    map
  end

  @since "0.4.0"
  def deep_map(map, key_function, value_function) when is_map(map) do
    Enum.into(map, %{}, fn
      {k, v} when is_map(v) or is_list(v) ->
        {key_function.(k), deep_map(v, key_function, value_function)}

      {k, v} ->
        {key_function.(k), value_function.(v)}
    end)
  end

  @since "0.4.0"
  def deep_map([head | rest], key_fun, value_fun) do
    [deep_map(head, key_fun, value_fun) | deep_map(rest, key_fun, value_fun)]
  end

  @since "0.4.0"
  def deep_map(nil, _key_fun, _value_fun) do
    nil
  end

  @since "0.4.0"
  def deep_map(value, _key_fun, value_fun) do
    value_fun.(value)
  end

  @doc """
  Transforms a `map`'s `String.t` keys to `atom()` keys.

  * `map` is any `Map.t`

  * `options` is a keyword list of options.  The
    available option is:

    * `:only_existing` which is set to `true` will
      only convert the binary key to an atom if the atom
      already exists.  The default is `false`.
  """
  @since "0.4.0"
  @spec atomize_keys(map(), keyword()) :: map()
  def atomize_keys(map, options \\ [only_existing: true]) do
    deep_map(map, &atomize_element(&1, options[:only_existing]), &identity/1)
  end

  @doc """
  Transforms a `map`'s `String.t` values to `atom()` values.

  * `map` is any `Map.t`

  * `options` is a keyword list of options.  The
    available option is:

    * `:only_existing` which is set to `true` will
      only convert the binary value to an atom if the atom
      already exists.  The default is `false`.
  """
  @since "0.4.0"
  @spec atomize_values(map(), keyword()) :: map()
  def atomize_values(map, options \\ [only_existing: false]) do
    deep_map(map, &identity/1, &atomize_element(&1, options[:only_existing]))
  end

  @doc """
  Transforms a `map`'s `atom()` keys to `String.t` keys.

  * `map` is any `Map.t`
  """
  @since "0.4.0"
  @spec stringify_keys(map()) :: map()
  def stringify_keys(map) do
    deep_map(
      map,
      fn
        k when is_atom(k) -> Atom.to_string(k)
        k -> k
      end,
      &identity/1
    )
  end

  @since "0.4.0"
  @spec identity(any) :: any
  defp identity(x), do: x

  @since "0.4.0"
  @spec atomize_element(String.t(), boolean) :: atom | no_return
  defp atomize_element(x, true) when is_binary(x) do
    try do
      String.to_existing_atom(x)
    rescue
      ArgumentError ->
        reraise(AtomizeKeyError, [key: x], __STACKTRACE__)
    end
  end

  @since "0.4.0"
  defp atomize_element(x, false) when is_binary(x), do: String.to_atom(x)
  @since "0.4.0"
  defp atomize_element(x, _), do: x
end
