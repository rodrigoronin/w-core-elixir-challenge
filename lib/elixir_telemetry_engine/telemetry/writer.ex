defmodule ElixirTelemetryEngine.Telemetry.Writer do
  use GenServer

  alias ElixirTelemetryEngine.Telemetry.Cache
  alias ElixirTelemetryEngine.Telemetry

  @interval 5_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:flush, state) do
    flush_to_db()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :flush, @interval)
  end

  defp flush_to_db do
    Cache.all() |> Enum.each(fn {node_id, data} ->
      Telemetry.upsert_node_metric(node_id, data)
    end)
  end
end
