defmodule ElixirTelemetryEngine.Telemetry.Ingestor do
  use GenServer

  alias ElixirTelemetryEngine.Telemetry.Cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def ingest(node_id, payload) do
    GenServer.cast(__MODULE__, {:ingest, node_id, payload})
  end

  ## Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:ingest, node_id, payload}, state) do
    IO.puts("INGEST RECEIVED")

    Cache.upsert(node_id, payload)

    Phoenix.PubSub.broadcast(
      ElixirTelemetryEngine.PubSub,
      "telemetry_updates",
      {:node_updated, node_id}
    )

    {:noreply, state}
  end
end
