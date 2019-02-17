defmodule StrawHat.ErrorMetadataTests do
  use ExUnit.Case, async: true
  doctest StrawHat.Error.ErrorMetadata

  test "creating an ErrorMetadata with a tuple" do
    metadata = StrawHat.Error.ErrorMetadata.new({:name, "yordis"})
    assert %StrawHat.Error.ErrorMetadata{key: "name", value: "yordis"} = metadata
  end
end
