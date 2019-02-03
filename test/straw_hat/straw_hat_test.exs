defmodule StrawHatTests do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  doctest StrawHat

  test "tap/2 always returns the subject" do
    assert StrawHat.tap("This is a tee!", fn text ->
             assert true
           end) == "This is a tee!"
  end
end
