defmodule ElixirTelemetryEngine.TelemetryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirTelemetryEngine.Telemetry` context.
  """

  @doc """
  Generate a node.
  """
  def node_fixture(attrs \\ %{}) do
    {:ok, node} =
      attrs
      |> Enum.into(%{
         location: "some  location",
         machine_identifier: "some  machine_identifier"
      })
      |> ElixirTelemetryEngine.Telemetry.create_node()

    node
  end

  @doc """
  Generate a node_metric.
  """
  def node_metric_fixture(attrs \\ %{}) do
    {:ok, node_metric} =
      attrs
      |> Enum.into(%{
         last_payload: %{},
         last_seen_at: ~U[2026-03-26 20:01:00Z],
         status: "some  status",
         total_events_processed: 42
      })
      |> ElixirTelemetryEngine.Telemetry.create_node_metric()

    node_metric
  end

  @doc """
  Generate a dashboard.
  """
  def dashboard_fixture(attrs \\ %{}) do
    {:ok, dashboard} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ElixirTelemetryEngine.Telemetry.create_dashboard()

    dashboard
  end
end
