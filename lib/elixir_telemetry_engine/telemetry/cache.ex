defmodule ElixirTelemetryEngine.Telemetry.Cache do
  @table :w_core_telemetry_cache

  def init do
    :ets.new(@table, [
      :named_table,
      :public,
      :set,
      read_concurrency: true,
      write_concurrency: true
    ])
  end

  def table, do: @table

  def upsert(node_id, payload) do
    case :ets.lookup(@table, node_id) do
      [] ->
        :ets.insert(@table, {node_id, payload})

      [{^node_id, existing}] ->
        updated = existing |> merge(payload)

        :ets.insert(@table, {node_id, payload})
    end
  end

  def all do
    :ets.tab2list(@table)
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
