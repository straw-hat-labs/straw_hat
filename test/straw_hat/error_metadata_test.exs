defmodule StrawHat.ErrorMetadataTest do
  use ExUnit.Case

  test "new/1 with tuple should create an ErrorMetadata" do
    metadata = StrawHat.Error.ErrorMetadata.new({:name, "yordis"})
    assert %StrawHat.Error.ErrorMetadata{key: "name", value: "yordis"} = metadata
  end
end
