defmodule ElixirTelemetryEngine.Telemetry.NodeMetric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "node_metrics" do
    field :" status", :string
    field :" total_events_process", :integer
    field :" last_payload", :map
    field :" last_seen_at", :utc_datetime
    field :" node_id", :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(node_metric, attrs) do
    node_metric
    |> cast(attrs, [:" status", :" total_events_process", :" last_payload", :" last_seen_at"])
    |> validate_required([:" status", :" total_events_process", :" last_seen_at"])
  end
end
