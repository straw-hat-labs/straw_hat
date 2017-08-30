defmodule StrawHat.GraphQL.Types do
  use Absinthe.Schema.Notation

  interface :node do
    field :id, non_null(:id)
  end

  interface :mutation_response do
    @desc "If the mutation happened without any problem"
    field :successful, non_null(:boolean)

    @desc "List of errors when the mutation fail (success: false)"
    field :errors, list_of(:error)
  end

  object :metadata do
    field :key, :string
    field :value, :string
  end

  object :error do
    field :id, non_null(:id)

    @desc "Identifier, use for know which error was"
    field :code, non_null(:string)

    @desc "General description of error"
    field :message, :string

    @desc "Information relative to the error"
    field :metadata, list_of(:metadata)
  end

  object :cursor_pagination_info do
    @desc "When paginating backwards, are there more items?"
    field :has_previous_page, non_null(:boolean)

    @desc "When paginating forwards, are there more items?"
    field :has_next_page, non_null(:boolean)

    @desc "When paginating backwards, the cursor to continue."
    field :start_cursor, :string

    @desc "When paginating forwards, the cursor to continue."
    field :end_cursor, :string
  end

  object :session do
    @desc "Information about authenticate token"
    field :access_token, non_null(:string)

    @desc "Information about token expiration"
    field :expiration_time, non_null(:integer)
  end

  input_object :page_params do
    @desc "Information relative to list page"
    field :page, non_null(:integer)

    @desc "Information relative to page size for list"
    field :page_size, non_null(:integer)
  end
end
