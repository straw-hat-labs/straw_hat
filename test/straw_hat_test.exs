defmodule StrawHatTest do
  use ExUnit.Case
  doctest StrawHat

  test "greets the world" do
    assert StrawHat.hello() == :world
  end
end
