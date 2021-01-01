defmodule Meliodas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    application = [
      # Start the Telemetry supervisor
      MeliodasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Meliodas.PubSub},
      # Start the Endpoint (http/https)
      MeliodasWeb.Endpoint
      # Start a worker by calling: Meliodas.Worker.start_link(arg)
      # {Meliodas.Worker, arg}
    ]

    packages = [
      {Finch, name: MeliodasFinch}
    ]

    services = [
      {Meliodas.Services.Forex.Job, %{}},
      {Meliodas.Services.Wttr.Job, %{}},
      {Meliodas.Services.Apify.Job, %{}},
      {Meliodas.Services.Rss.Job, %{}},
      {Meliodas.Services.Speedtest.Job, %{}}
    ]

    children = application ++ packages ++ services

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Meliodas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MeliodasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
