defmodule StrawHat.Error do
  @moduledoc """
  Used for Error handling. The StrawHat's philosophy is to have data structure
  as much as we can.

  ### Usage

  One example of the struct could be with Ecto. When you want to find some
  record but it does not exists on the database.

  ## Examples

      case Repo.get(UserSchema, id) do
        nil -> {:error, StrawHat.Error.new("user.not_found", metadata: [user_id: id])}
        user -> {:ok, user}
      end
  """

  alias Uniq.UUID
  alias StrawHat.Error.ErrorMetadata

  @type opts :: [type: String.t(), metadata: Keyword.t()]

  @typedoc """
  - `id`: Unique identifier setup by the System. Used for tracking, it's unique
  per instance of the Error. Default: `UUID.uuid1()`.
  - `code`: Represent the ID defined by your system designed. Example: `"straw_hat.validation.required"`
  - `type`:  Categorize/Group your errors. Default `"generic"`.
  - `metadata`: A set of key value with useful information about the error.
  """
  @type t :: %__MODULE__{
          id: String.t(),
          code: String.t(),
          type: String.t(),
          metadata: [ErrorMetadata.t()]
        }

  @enforce_keys [:id, :code]
  defstruct [:id, :code, :type, :metadata]

  if Code.ensure_loaded?(Ecto) do
    alias StrawHat.Error.{ChangesetParser, ErrorList}

    @doc """
    Converts an `t:Ecto.Changeset.t/0` to `t:StrawHat.Error.ErrorList.t/0` error.
    """
    @spec new(Ecto.Changeset.t()) :: StrawHat.Error.ErrorList.t()
    def new(%Ecto.Changeset{} = changeset) do
      changeset
      |> ChangesetParser.parse()
      |> ErrorList.new()
    end
  end

  @doc """
  Returns a `t:StrawHat.Error.t/0`.
  """
  @spec new(String.t(), opts()) :: t
  def new(code, opts \\ []) do
    type = Keyword.get(opts, :type, "generic")

    metadata =
      opts
      |> Keyword.get(:metadata, [])
      |> ErrorMetadata.serialize()

    id = Keyword.get_lazy(opts, :id, generate_id)

    %__MODULE__{id: id, code: code, type: type, metadata: metadata}
  end

  defp generate_id do
    Application.get_env(:straw_hat, :id_generator, &Uniq.UUID.uuid1/0)
  end
end
