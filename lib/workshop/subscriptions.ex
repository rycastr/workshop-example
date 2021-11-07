defmodule Workshop.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false

  alias Workshop.Schemas.Subscription

  @doc """
  Returns the list of Subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Mongo.find(:mongo, "subscriptions", %{})
    |> Enum.to_list()
    |> Enum.map(fn subscription -> Subscription.from_map(subscription) end)
  end

  @doc """
  Gets a single Subscription.

  Raises if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

  """
  def get_subscription!(id) do
    case Mongo.find_one(:mongo, "subscriptions", %{_id: BSON.ObjectId.decode!(id)}) do
      nil -> raise "subscription not exists"
      subscription -> Subscription.from_map(subscription)
    end
  end

  @doc """
  Creates a Subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, ...}

  """
  def create_subscription(attrs \\ %{}) do
    changeset = Subscription.changeset(attrs)

    with {:ok, subscription} <- Ecto.Changeset.apply_action(changeset, :create) do
      Mongo.insert_one(:mongo, "subscriptions", subscription)
    end
  end

  @doc """
  Updates a Subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, ...}

  """
  def update_subscription(id, attrs) do
    changeset = Subscription.changeset(attrs)

    with {:ok, subscription} <- Ecto.Changeset.apply_action(changeset, :update) do
      IO.inspect(subscription)

      Mongo.update_one(:mongo, "subscriptions", %{_id: BSON.ObjectId.decode!(id)}, %{
        "$set": subscription
      })
      |> IO.inspect()
    end
  end

  @doc """
  Deletes a Subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, ...}

  """
  def delete_subscription(id) do
    Mongo.delete_one(:mongo, "subscriptions", %{_id: BSON.ObjectId.decode!(id)})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end
end
