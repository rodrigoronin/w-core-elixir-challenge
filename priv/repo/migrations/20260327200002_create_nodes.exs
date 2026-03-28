defmodule ElixirTelemetryEngine.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :machine_identifier, :string
      add :location, :string

      timestamps(type: :utc_datetime)
    end
  end
end
