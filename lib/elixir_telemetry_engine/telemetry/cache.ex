defmodule ElixirTelemetryEngine.Telemetry.Cache do
  use GenServer

  @table :w_core_telemetry_cache

  ## START

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  ## CALLBACKS

  @impl true
  def init(_) do
    :ets.new(@table, [
      :named_table,
      :public,
      :set,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{}}
  end

  ## API

  def upsert(node_id, payload) do
    case :ets.lookup(@table, node_id) do
      [] ->
        :ets.insert(@table, {node_id, build_new(payload)})

      [{^node_id, existing}] ->
        updated = merge(existing, payload)
        :ets.insert(@table, {node_id, updated})
    end
  end

  def all do
    :ets.tab2list(@table)
  end

  defp build_new(payload) do
    %{
      status: payload.status,
      event_count: 1,
      last_payload: payload,
      last_seen_at: DateTime.utc_now()
    }
  end

  defp merge(existing, payload) do
    %{
      status: payload.status || existing.status,
      event_count: existing.event_count + 1,
      last_payload: payload,
      last_seen_at: DateTime.utc_now()
    }
  end
end
