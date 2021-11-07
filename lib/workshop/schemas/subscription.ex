defmodule Workshop.Schemas.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @email_regex ~r/^[a-z0-9]([\.\_]{0,1}[a-z0-9])+[\.\_]{0,1}[@][a-z0-9](([\-]{0,1}[a-z0-9]{1}){0,}[.])[a-z]{2,}$/

  embedded_schema do
    field :email, :string
    field :full_name, :string
  end

  defimpl Mongo.Encoder do
    @spec encode(%Workshop.Schemas.Subscription{}) :: map()
    def encode(%{id: nil, full_name: full_name, email: email}) do
      %{
        full_name: full_name,
        email: email
      }
    end

    def encode(%{id: id, full_name: full_name, email: email}) do
      %{
        _id: id,
        full_name: full_name,
        email: email
      }
    end
  end

  @spec changeset(%__MODULE__{}, any()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, attrs) do
    struct
    |> cast(attrs, [:full_name, :email])
    |> validate_required([:full_name, :email])
    |> validate_format(:email, @email_regex)
  end

  @spec from_map(map()) :: %Workshop.Schemas.Subscription{}
  def from_map(subscription_map) do
    Enum.reduce(subscription_map, %__MODULE__{}, fn
      {"_id", value}, acc -> Map.put(acc, :id, BSON.ObjectId.encode!(value))
      {key, value}, acc -> Map.put(acc, String.to_atom(key), value)
    end)
  end
end
