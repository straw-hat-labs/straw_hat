defmodule StrawHat.Test.MapTest do
  use ExUnit.Case
  alias StrawHat.Utils.Map

  describe "atomize_keys/2" do
    test "with only existing atoms" do
      assert %{hello: "world"} == Map.atomize_keys(%{"hello" => "world"})

      assert_raise ArgumentError,
                   "\"PepeHands\" binary hasn't been used on the system as an atom",
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

  test "atomize_values/2" do
    assert %{"hello" => :world} == Map.atomize_values(%{"hello" => "world"})
  end

  test "stringify_keys/1" do
    assert %{"newKeyInTown" => "yeah"} == Map.stringify_keys(%{newKeyInTown: "yeah"})
    assert %{"FeelsGoodMan" => "Kappa123"} == Map.stringify_keys(%{"FeelsGoodMan" => "Kappa123"})
  end

  test "deep_map/2" do
    assert 1 == Map.deep_map(1, fn x -> x end)
    assert %{hello: "world"} == Map.deep_map(%{hello: "world"}, fn x -> x end)
  end

  test "deep_map/3" do
    assert 1 == Map.deep_map(1, 1, fn x -> x end)
  end
end
