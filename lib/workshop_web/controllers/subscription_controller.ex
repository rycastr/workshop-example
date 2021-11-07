defmodule WorkshopWeb.SubscriptionController do
  use WorkshopWeb, :controller

  alias Workshop.Subscriptions
  alias Workshop.Schemas.Subscription

  def index(conn, _params) do
    subscriptions = Subscriptions.list_subscriptions()
    render(conn, "index.html", subscriptions: subscriptions)
  end

  def new(conn, _params) do
    changeset = Subscriptions.change_subscription(%Subscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    case Subscriptions.create_subscription(subscription_params) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Subscription created successfully.")
        |> redirect(to: Routes.subscription_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = Subscriptions.get_subscription!(id)
    render(conn, "show.html", subscription: subscription)
  end

  def edit(conn, %{"id" => id}) do
    subscription = Subscriptions.get_subscription!(id)
    %{data: data} = changeset = Subscriptions.change_subscription(subscription)

    render(conn, "edit.html",
      subscription: subscription,
      changeset: %{changeset | data: Map.put_new(data, :__meta__, %{state: :loaded})}
    )
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Subscriptions.get_subscription!(id)

    case Subscriptions.update_subscription(subscription.id, subscription_params) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: Routes.subscription_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", subscription: subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = Subscriptions.get_subscription!(id)
    {:ok, _result} = Subscriptions.delete_subscription(subscription.id)

    conn
    |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: Routes.subscription_path(conn, :index))
  end
end
