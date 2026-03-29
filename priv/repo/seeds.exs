alias ElixirTelemetryEngine.Repo
alias ElixirTelemetryEngine.Telemetry
alias ElixirTelemetryEngine.Telemetry.Node

nodes = [
  %{machine_identifier: "sensor_1", location: "line_a"},
  %{machine_identifier: "sensor_2", location: "line_a"},
  %{machine_identifier: "sensor_3", location: "line_b"},
  %{machine_identifier: "sensor_4", location: "line_c"},
  %{machine_identifier: "sensor_5", location: "line_c"}
]

Enum.each(nodes, fn attrs ->
  case Repo.get_by(Node, machine_identifier: attrs.machine_identifier) do
    nil ->
      {:ok, _} = Telemetry.create_node(attrs)
      IO.puts("Created #{attrs.machine_identifier}")

    _node ->
      IO.puts("Already exists: #{attrs.machine_identifier}")
  end
end)
