defmodule StrawHat.Error do
  @moduledoc """
  Used for Error handling. The StrawHat's philosophy is to have data structure
  as much as we can.

  ## %StrawHat.Error{}

    * `id`: Unique identifier setup by the System. Used for tracking, it's unique
  per instance of the Error. Default: `UUID.uuid1()`.
    * `code`: Represent the ID defined by your system designed. Example: `"straw_hat.validation.required"`
    * `type`:  Categorize/Group your errors. Default `"generic"`.
    * `metadata`: A set of key value with useful information about the error.

  ### Usage
  One example of the struct could be with Ecto. When you want to find some record
  but it does not exists on the database.

      case Repo.get(UserSchema, id) do
        nil -> {:error, StrawHat.Error.new("user.not_found", metadata: [user_id: id])}
        user -> {:ok, user}
      end
  """

  alias StrawHat.Error
  alias StrawHat.Error.{ChangesetParser, ErrorList, ErrorMetadata}

  @type opts :: [type: String.t, metadata: Keyword.t]
  @type t :: %StrawHat.Error{id: String.t,
                             code: String.t,
                             type: String.t,
                             metadata: ErrorMetadata.t}

  @enforce_keys [:id, :code]
  defstruct [:id, :code, :type, :metadata]

  @doc """
  Converts an `Ecto.Changeset` to `%StrawHat.Error.ErrorList{}` error.
  """
  @spec new(Ecto.Changeset.t) :: StrawHat.Error.ErrorList.t
  def new(%Ecto.Changeset{} = changeset) do
    changeset
    |> ChangesetParser.parse()
    |> ErrorList.new()
  end

  @doc """
  Returns an `%StrawHat.Error{}`.
  """
  @spec new(String.t, opts) :: t
  def new(code, opts \\ []) do
    type = Keyword.get(opts, :type, "generic")
    metadata =
      opts
      |> Keyword.get(:metadata, [])
      |> ErrorMetadata.serialize()

    %Error{
      id: UUID.uuid1(),
      code: code,
      type: type,
      metadata: metadata}
  end
end
