defmodule Powerpak.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PowerpakWeb.Telemetry,
      Powerpak.Repo,
      {DNSCluster, query: Application.get_env(:powerpak, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Powerpak.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Powerpak.Finch},
      # Start a worker by calling: Powerpak.Worker.start_link(arg)
      # {Powerpak.Worker, arg},
      # Start to serve requests, typically the last entry
      PowerpakWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Powerpak.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PowerpakWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
