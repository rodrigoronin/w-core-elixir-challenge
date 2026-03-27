defmodule ElixirTelemetryEngine.Repo do
  use Ecto.Repo,
    otp_app: :elixir_telemetry_engine,
    adapter: Ecto.Adapters.SQLite3
end
