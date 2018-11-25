defmodule StrawHat.Response do
  @moduledoc """
  Utilities for working with "result tuples".

  * `{:ok, value}`
  * `{:error, reason}`
  """

  @type t(ok, error) :: {:ok, ok} | {:error, error}
  @type ok_tuple :: {:ok, any}
  @type error_tuple :: {:error, any}
  @type result_tuple :: ok_tuple | error_tuple

  @doc ~S"""
  Calls the next function only if it receives an ok tuple. Otherwise it skips the call and
  returns the error tuple.

  ## Examples

      iex> business_logic = fn x -> StrawHat.Response.ok(x * 2) end
      ...> 21 |> StrawHat.Response.ok() |> StrawHat.Response.and_then(business_logic)
      {:ok, 42}

      iex> business_logic = fn x -> StrawHat.Response.ok(x * 2) end
      ...> "oops" |> StrawHat.Response.error() |> StrawHat.Response.and_then(business_logic)
      {:error, "oops"}
  """
  @since "0.4.0"
  @spec and_then(result_tuple, (any -> result_tuple)) :: result_tuple
  def and_then({:ok, data}, function), do: function.(data)

  @since "0.4.0"
  def and_then({:error, _} = error, _function), do: error

  @doc ~S"""
  Calls the first function if it receives an error tuple, and the second one if it receives an ok
  tuple.

  ## Examples

      iex> on_ok = fn x -> "X is #{x}" end
      ...> on_error = fn e -> "Error: #{e}" end
      ...> 42 |> StrawHat.Response.ok() |> StrawHat.Response.either(on_error, on_ok)
      "X is 42"

      iex> on_ok = fn x -> "X is #{x}" end
      ...> on_error = fn e -> "Error: #{e}" end
      ...> "oops" |> StrawHat.Response.error() |> StrawHat.Response.either(on_error, on_ok)
      "Error: oops"
  """
  @since "0.4.0"
  @spec either(result_tuple, (any -> any), (any -> any)) :: any
  def either({:ok, data}, _, on_ok), do: on_ok.(data)

  @since "0.4.0"
  def either({:error, error}, on_error, _), do: on_error.(error)

  @doc ~S"""
  Creates a new error result tuple.

  ## Examples

      iex> StrawHat.Response.error("oops")
      {:error, "oops"}
  """
  @since "0.4.0"
  @spec error(any) :: error_tuple
  def error(value), do: {:error, value}

  @doc ~S"""
  Checks if a `result_tuple` is an error.

  ## Examples

      iex> 1 |> StrawHat.Response.ok() |> StrawHat.Response.error?()
      false

      iex> 2 |>StrawHat.Response.error() |> StrawHat.Response.error?()
      true
  """
  @since "0.4.0"
  @spec error?(result_tuple) :: boolean
  def error?({:error, _}), do: true

  @since "0.4.0"
  def error?({:ok, _}), do: false

  @doc ~S"""
  Promotes any value to a result tuple. It excludes `nil` for the
  ok tuples.

  ## Examples

      iex> StrawHat.Response.from_value(nil)
      {:error, :no_value}

      iex> StrawHat.Response.from_value(42)
      {:ok, 42}
  """
  @since "0.4.0"
  @spec from_value(any) :: result_tuple
  def from_value(value, on_nil_value \\ :no_value)

  @since "0.4.0"
  def from_value(nil, on_nil_value), do: error(on_nil_value)

  @since "0.4.0"
  def from_value(value, _on_nil_value), do: ok(value)

  @doc ~S"""
  Converts an `Ok` value to an `Error` value if the `predicate` is not valid.

  ## Examples

      iex> res = StrawHat.Response.ok(10)
      ...> StrawHat.Response.keep_if(res, &(&1 > 5))
      {:ok, 10}

      iex> res = StrawHat.Response.ok(10)
      ...> StrawHat.Response.keep_if(res, &(&1 > 10), "must be > of 10")
      {:error, "must be > of 10"}

      iex> res = StrawHat.Response.error(:no_value)
      ...> StrawHat.Response.keep_if(res, &(&1 > 10), "must be > of 10")
      {:error, :no_value}
  """
  @since "0.4.0"
  @spec keep_if(result_tuple, (any -> boolean), any) :: result_tuple
  def keep_if(result, predicate, error_message \\ :invalid)

  @since "0.4.0"
  def keep_if({:error, _} = error, _predicate, _error_message), do: error

  @since "0.4.0"
  def keep_if({:ok, value} = ok, predicate, error_message) do
    if predicate.(value), do: ok, else: error(error_message)
  end

  @doc ~S"""
  Calls the next function only if it receives an ok tuple. The function unwraps the value
  from the tuple, calls the next function and wraps it back into an ok tuple.

  ## Examples

      iex> business_logic = fn x -> x * 2 end
      ...> 21 |> StrawHat.Response.ok() |> StrawHat.Response.map(business_logic)
      {:ok, 42}

      iex> business_logic = fn x -> x * 2 end
      ...> "oops" |> StrawHat.Response.error() |> StrawHat.Response.map(business_logic)
      {:error, "oops"}
  """
  @since "0.4.0"
  @spec map(result_tuple, (any -> any)) :: result_tuple
  def map({:ok, data}, function), do: ok(function.(data))

  @since "0.4.0"
  def map({:error, _} = error, _function), do: error

  @doc ~S"""
  Calls the next function only if it receives an error tuple. The function unwraps the value
  from the tuple, calls the next function and wraps it back into an error tuple.

  ## Examples

      iex> better_error = fn _ -> "A better error message" end
      ...> 42 |> StrawHat.Response.ok() |> StrawHat.Response.map_error(better_error)
      {:ok, 42}

      iex> better_error = fn _ -> "A better error message" end
      ...> "oops" |> StrawHat.Response.error() |> StrawHat.Response.map_error(better_error)
      {:error, "A better error message"}
  """
  @since "0.4.0"
  @spec map_error(result_tuple, (any -> any)) :: result_tuple
  def map_error({:ok, _} = data, _function), do: data

  @since "0.4.0"
  def map_error({:error, _} = error, function) do
    or_else(error, fn x -> error(function.(x)) end)
  end

  @doc ~S"""
  Creates a new ok result tuple.

  ## Examples

      iex> StrawHat.Response.ok(42)
      {:ok, 42}
  """
  @since "0.4.0"
  @spec ok(any) :: ok_tuple
  def ok(value), do: {:ok, value}

  @doc ~S"""
  Checks if a `result_tuple` is ok.

  ## Examples

      iex> 1 |> StrawHat.Response.ok() |> StrawHat.Response.ok?()
      true

      iex> 2 |> StrawHat.Response.error() |>StrawHat.Response.ok?()
      false
  """
  @since "0.4.0"
  @spec ok?(result_tuple) :: boolean
  def ok?({:ok, _}), do: true

  @since "0.4.0"
  def ok?({:error, _}), do: false

  @doc ~S"""
  Calls the next function only if it receives an ok tuple but discards the result. It always returns
  the original tuple.

  ## Examples

      iex> some_logging = fn x -> IO.puts "Success #{x}" end
      ...> {:ok, 42} |> StrawHat.Response.tap(some_logging)
      {:ok, 42}

      iex> some_logging = fn _ -> IO.puts "Not called logging" end
      ...> {:error, "oops"} |> StrawHat.Response.tap(some_logging)
      {:error, "oops"}
  """
  @since "0.4.0"
  @spec tap(result_tuple, (any -> any)) :: result_tuple
  def tap(data, function), do: map(data, &StrawHat.tap(&1, function))

  @doc ~S"""
  Calls the next function only if it receives an error tuple but discards the result. It always returns
  the original tuple.

  ## Examples

    iex> some_logging = fn x -> IO.puts "Failed #{x}" end
    ...> {:error, "oops"} |> StrawHat.Response.tap_error(some_logging)
    {:error, "oops"}

    iex> some_logging = fn _ -> IO.puts "Not called logging" end
    ...> {:ok, 42} |> StrawHat.Response.tap_error(some_logging)
    {:ok, 42}
  """
  @since "0.4.0"
  @spec tap_error(result_tuple, (any -> any)) :: result_tuple
  def tap_error(data, function), do: map_error(data, &StrawHat.tap(&1, function))

  @doc ~S"""
  Calls the next function only if it receives an error tuple. Otherwise it skips the call and returns the
  ok tuple. It expects the function to return a new result tuple.

  ## Examples

      iex> business_logic = fn _ -> {:error, "a better error message"} end
      ...> {:ok, 42} |> StrawHat.Response.or_else(business_logic)
      {:ok, 42}

      iex> business_logic = fn _ -> {:error, "a better error message"} end
      ...> {:error, "oops"} |> StrawHat.Response.or_else(business_logic)
      {:error, "a better error message"}

      iex> default_value = fn _ -> {:ok, []} end
      ...> {:error, "oops"} |> StrawHat.Response.or_else(default_value)
      {:ok, []}
  """
  @since "0.4.0"
  @spec or_else(result_tuple, (any -> result_tuple)) :: result_tuple
  def or_else({:ok, _} = data, _function), do: data

  @since "0.4.0"
  def or_else({:error, reason}, function), do: function.(reason)

  @doc ~S"""
  Converts an `Ok` value to an `Error` value if the `predicate` is valid.

  ## Examples

      iex> res = StrawHat.Response.ok([])
      ...> StrawHat.Response.reject_if(res, &Enum.empty?/1)
      {:error, :invalid}

      iex> res = StrawHat.Response.ok([1])
      ...> StrawHat.Response.reject_if(res, &Enum.empty?/1)
      {:ok, [1]}

      iex> res = StrawHat.Response.ok([])
      ...> StrawHat.Response.reject_if(res, &Enum.empty?/1, "list cannot be empty")
      {:error, "list cannot be empty"}
  """
  @since "0.4.0"
  @spec reject_if(result_tuple, (any -> boolean), any) :: result_tuple
  def reject_if(result, predicate, error_message \\ :invalid) do
    keep_if(result, &(not predicate.(&1)), error_message)
  end

  @doc ~S"""
  Transforms a list of result tuple to a result tuple containing either
  the first error tuple or an ok tuple containing the list of values.

  ### Examples

      iex> StrawHat.Response.sequence([StrawHat.Response.ok(42), StrawHat.Response.ok(1337)])
      {:ok, [42, 1337]}

      iex> StrawHat.Response.sequence([StrawHat.Response.ok(42), StrawHat.Response.error("oops"), StrawHat.Response.ok(1337)])
      {:error, "oops"}
  """
  @since "0.4.0"
  @spec sequence([result_tuple]) :: {:ok, [any()]} | {:error, any()}
  def sequence(list) do
    case Enum.reduce_while(list, [], &do_sequence/2) do
      {:error, _} = error -> error
      result -> ok(Enum.reverse(result))
    end
  end

  @doc ~S"""
  Returns the content of an ok tuple if the value is correct. Otherwise it returns the
  default value.

  ### Examples

      iex> 42 |> StrawHat.Response.ok |> StrawHat.Response.with_default(1337)
      42

      iex> "oops" |> StrawHat.Response.error |> StrawHat.Response.with_default(1337)
      1337
  """
  @since "0.4.0"
  @spec with_default(result_tuple, any) :: any
  def with_default({:ok, data}, _default_data), do: data

  @since "0.4.0"
  def with_default({:error, _}, default_data), do: default_data

  defp do_sequence(element, elements) do
    case element do
      {:ok, value} -> {:cont, [value | elements]}
      {:error, _} -> {:halt, element}
    end
  end
end
