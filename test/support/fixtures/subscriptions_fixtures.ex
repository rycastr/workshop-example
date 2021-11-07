defmodule Workshop.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Workshop.Subscriptions` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        email: "some email",
        full_name: "some full_name"
      })
      |> Workshop.Subscriptions.create_subscription()

    subscription
  end
end
