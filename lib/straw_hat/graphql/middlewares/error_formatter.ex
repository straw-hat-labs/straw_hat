defmodule StrawHat.GraphQL.Middleware.ErrorFormatterMiddleware do
  @behaviour Absinthe.Middleware

  alias StrawHat.Error.ErrorList

  def call(%Absinthe.Resolution{errors: []} = resolution, _config), do: resolution
  def call(%Absinthe.Resolution{errors: errors} = resolution, _config) do
    %{resolution | errors: ErrorList.new(errors)}
  end
  def call(resolution, _config), do: resolution
end
