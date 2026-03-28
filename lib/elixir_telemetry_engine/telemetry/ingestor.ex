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
    Cache.upsert(node_id, payload)

    {:noreply, state} # TODO: change for PubSub later
  end
end
