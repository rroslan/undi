defmodule Undi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UndiWeb.Telemetry,
      Undi.Repo,
      {DNSCluster, query: Application.get_env(:undi, :dns_cluster_query) || :ignore},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:undi, :ash_domains),
         Application.fetch_env!(:undi, Oban)
       )},
      # Start the Finch HTTP client for sending emails
      # Start a worker by calling: Undi.Worker.start_link(arg)
      # {Undi.Worker, arg},
      # Start to serve requests, typically the last entry
      {Phoenix.PubSub, name: Undi.PubSub},
      {Finch, name: Undi.Finch},
      UndiWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :undi]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Undi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UndiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
