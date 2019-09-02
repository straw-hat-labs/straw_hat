defmodule StrawHat.ConfigurableTest do
  use ExUnit.Case, async: true
  alias StrawHat.TestSupport.MockApp

  test "returning the configuration" do
    config = MockApp.config([hello: "World"])
    assert Keyword.get(config, :hello) == "World"
    assert Keyword.get(config, :site) == "https://github.com/straw-hat-team/straw_hat"
    assert Keyword.get(config, :json_library) == "Jason"
  end
end
