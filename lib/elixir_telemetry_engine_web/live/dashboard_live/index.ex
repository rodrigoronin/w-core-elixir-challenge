defmodule ElixirTelemetryEngineWeb.DashboardLive.Index do
  use ElixirTelemetryEngineWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(
        ElixirTelemetryEngine.PubSub,
        "telemetry_updates"
      )
    end

    {:ok, assign(socket, nodes: load_nodes())}
  end

  defp load_nodes do
    case :ets.info(:w_core_telemetry_cache) do
      :undefined ->
        []

      _ ->
        :ets.tab2list(:w_core_telemetry_cache)
        |> Enum.map(fn {node_id, data} ->
          %{node_id: node_id} |> Map.merge(data)
        end)
    end
  end

  @impl true
  def handle_info({:node_updated, _node_id}, socket) do
    {:noreply, assign(socket, nodes: load_nodes())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Telemetry Dashboard</h1>

      <table>
        <thead>
          <tr>
            <th>Node</th>
            <th>Status</th>
            <th>Events</th>
            <th>Last update</th>
          </tr>
        </thead>

        <tbody>
          <%= for node <- @nodes do %>
            <tr>
              <td><%= node.node_id %></td>
              <td><%= node.status %></td>
              <td><%= node.event_count %></td>
              <td><%= node.last_seen_at %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
