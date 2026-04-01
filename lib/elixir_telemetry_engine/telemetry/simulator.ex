defmodule ElixirTelemetryEngine.Telemetry.SensorSimulator do
  use GenServer

  alias ElixirTelemetryEngine.Telemetry
  alias ElixirTelemetryEngine.Telemetry.Ingestor

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    send(self(), :auto_start)
    {:ok, %{running: false}}
  end

  def start do
    GenServer.cast(__MODULE__, :start_simulation)
  end

  def stop do
    GenServer.cast(__MODULE__, :stop_simulation)
  end

  @impl true
  def handle_cast(:start_simulation, state) do
    if state.running do
      {:noreply, state}
    else
      spawn_simulation()
      {:noreply, %{state | running: true}}
    end
  end

  def handle_cast(:stop_simulation, state) do
    {:noreply, %{state | running: false}}
  end

  @impl true
  def handle_info(:auto_start, state) do
    case Telemetry.list_nodes() do
      [] ->
        Process.send_after(self(), :auto_start, 1000)
        {:noreply, state}

      _nodes ->
        spawn_simulation()
        {:noreply, %{state | running: true}}
    end
  end

  defp spawn_simulation do
    Telemetry.list_nodes()
    |> Enum.each(fn node ->
      spawn(fn -> loop(node.id, self()) end)
    end)
  end

  defp loop(node_id, server) do
    receive do
      :stop ->
        :ok
    after
      :rand.uniform(2000) ->
        Ingestor.ingest(node_id, random_payload())
        loop(node_id, server)
    end
  end

  @impl true
  def handle_call(:running?, _from, state) do
    {:reply, state.running, state}
  end

  defp random_payload do
    %{
      status: Enum.random(["ok", "fail", "warning"])
    }
  end
end
