defmodule ElixirTelemetryEngine.Repo.Migrations.CreateNodeMetrics do
  use Ecto.Migration

  def change do
    create table(:node_metrics) do
      add :status, :string
      add :total_events_process, :integer
      add :last_payload, :map
      add :last_seen_at, :utc_datetime
      add :node_id, references(:nodes, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:node_metrics, [:node_id])
  end
end
