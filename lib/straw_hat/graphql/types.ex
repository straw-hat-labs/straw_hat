defmodule StrawHat.GraphQL.Types do
  use Absinthe.Schema.Notation

  interface :node do
    field :id, non_null(:id)
  end

  interface :mutation_response do
    @desc "If the mutation happened without any problem"
    field :success, non_null(:boolean)

    @desc "list of errors when the mutation fail (success: false)"
    field :errors, list_of(:error)
  end

  object :metadata do
    field :key, :string
    field :value, :string
  end

  object :error do
    field :id, non_null(:id)
    field :code, non_null(:string)
    field :type, :string
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
end
