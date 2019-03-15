defmodule StrawHatTest do
  use ExUnit.Case, async: true
  doctest StrawHat

  test "tap/2 always returns the subject" do
    assert StrawHat.tap("This is a tee!", fn text ->
             assert text == "This is a tee!"
           end) == "This is a tee!"
  end
end
