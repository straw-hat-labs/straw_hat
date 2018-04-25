defmodule StrawHatTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest StrawHat

  test "tap/2 always returns the subject" do
    assert capture_io(fn ->
             assert StrawHat.tap("This is a tee!", &IO.puts(String.length(&1))) ==
                      "This is a tee!"
           end) == "14\n"
  end
end
