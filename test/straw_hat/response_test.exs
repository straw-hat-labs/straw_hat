defmodule StrawHat.ResponseTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest StrawHat.Response

  test "tap: calls the function and returns original data" do
    original = StrawHat.Response.ok("World")

    assert "Hello World\n" == capture_io(fn ->
      assert original == StrawHat.Response.tap(original, fn name -> IO.puts "Hello #{name}" end)
    end)
  end

  test "tap: does not call the function and returns original data" do
    original = StrawHat.Response.error("Oops")

    assert "" == capture_io(fn ->
      assert original == StrawHat.Response.tap(original, fn name -> IO.puts "Hello #{name}" end)
    end)
  end

  test "tap_error: does not call the function and returns original data" do
    original = StrawHat.Response.ok("World")

    assert "" == capture_io(fn ->
      assert original == StrawHat.Response.tap_error(original, fn name -> IO.puts "Hello #{name}" end)
    end)
  end

  test "tap_error: does call the function and returns original data" do
    original = StrawHat.Response.error("Oops")

    assert "Hello Oops\n" == capture_io(fn ->
      assert original == StrawHat.Response.tap_error(original, fn name -> IO.puts "Hello #{name}" end)
    end)
  end
end
