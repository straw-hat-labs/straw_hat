defmodule StrawHat.ResponseTests do
  use ExUnit.Case, async: true
  alias StrawHat.Response

  doctest Response

  describe "tap/2" do
    test "calls the function and returns original data" do
      original = Response.ok("Hello, World")

      assert original ==
               Response.tap(original, fn text ->
                 assert text == "Hello, World"
               end)
    end

    test "does not call the function and returns original data" do
      original = Response.error("Oops")

      assert original == Response.tap(original, fn _message -> assert false end)
    end
  end

  describe "tap_error/2" do
    test "does not call the function and returns original data" do
      original = Response.ok("World")

      assert original == Response.tap_error(original, fn _message -> assert false end)
    end

    test "does call the function and returns original data" do
      original = Response.error("Oops")

      assert original == Response.tap_error(original, fn message -> assert message == "Oops" end)
    end
  end
end
