defmodule StrawHat.MapTest do
  use ExUnit.Case
  alias StrawHat.Utils.Map

  defmodule MyApp do
    defstruct [:name]
  end

  describe "atomize_keys/2" do
    test "with only existing atoms" do
      assert %{hello: "world"} == Map.atomize_keys(%{"hello" => "world"})

      assert_raise Map.AtomizeKeyError,
                   "\"PepeHands\" binary hasn't been used on the system as an atom before",
                   fn ->
                     Map.atomize_keys(%{"PepeHands" => "kappa 123"})
                   end
    end

    test "without only existing flag" do
      assert %{newKeyInTown: "yeah"} ==
               Map.atomize_keys(%{"newKeyInTown" => "yeah"}, only_existing: false)

      assert %{"newKeyInTown" => "yeah"} ==
               Map.atomize_keys(%{"newKeyInTown" => "yeah"}, only_existing: "wuahaha")
    end
  end

  test "atomize_values/2 should convert the value to a atom value" do
    assert %{"hello" => :world} == Map.atomize_values(%{"hello" => "world"})
  end

  test "stringify_keys/1 should convert the keys to strings" do
    assert %{"newKeyInTown" => "yeah"} == Map.stringify_keys(%{newKeyInTown: "yeah"})
    assert %{"FeelsGoodMan" => "Kappa123"} == Map.stringify_keys(%{"FeelsGoodMan" => "Kappa123"})
  end

  test "deep_map/2" do
    assert %MyApp{name: "hello"} == Map.deep_map(%MyApp{name: "hello"}, fn x -> x end)
    assert 1 == Map.deep_map(1, fn x -> x end)
    assert %{hello: "world"} == Map.deep_map(%{hello: "world"}, fn x -> x end)
  end

  test "deep_map/3" do
    assert %MyApp{name: "hello"} == Map.deep_map(%MyApp{name: "hello"}, 1, fn x -> x end)
    assert 1 == Map.deep_map(1, 1, fn x -> x end)
  end
end
