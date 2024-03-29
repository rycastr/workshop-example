defmodule Workshop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WorkshopWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Workshop.PubSub},
      # Start the Endpoint (http/https)
      WorkshopWeb.Endpoint,
      {Mongo, [name: :mongo, url: "mongodb://localhost:27017/workshop", pool_size: 2]}
      # Start a worker by calling: Workshop.Worker.start_link(arg)
      # {Workshop.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Workshop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WorkshopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
