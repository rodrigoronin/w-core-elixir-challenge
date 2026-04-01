defmodule ElixirTelemetryEngine.Telemetry.ConcurrencyTest do
  use ElixirTelemetryEngine.DataCase

  alias ElixirTelemetryEngine.Telemetry
  alias ElixirTelemetryEngine.Telemetry.Ingestor

  @events 10_000

  test "handles 10k concurrent events without losing data" do
    {:ok, node} =
      Telemetry.create_node(%{
        machine_identifier: "sensor_1",
        location: "line_a"
      })

    # dispara eventos concorrentes
    1..@events
    |> Task.async_stream(fn _ ->
      Ingestor.ingest(node.id, %{status: "ok"})
    end,
      max_concurrency: System.schedulers_online() * 4,
      timeout: :infinity
    )
    |> Stream.run()

    # espera writer persistir
    Process.sleep(6_000)

    # ETS
    node_id = node.id

    [{^node_id, data}] =
      :ets.lookup(:w_core_telemetry_cache, node_id)

    # DB
    metric = Telemetry.get_node_metric_by_node_id(node.id)

    IO.puts("=== RESULTS ===")
    IO.inspect(data.event_count, label: "ETS COUNT")
    IO.inspect(metric.total_events_processed, label: "DB COUNT")

    assert data.event_count == @events
    assert metric.total_events_processed == @events
  end
end
