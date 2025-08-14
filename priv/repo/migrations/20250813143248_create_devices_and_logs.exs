defmodule SmartHome.Repo.Migrations.CreateDevicesAndLogs do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string, null: false
      add :status, :string, null: false, default: "off"
      add :last_seen, :utc_datetime_usec
      timestamps()
    end

    create table(:device_attributes) do
      add :device_id, :binary_id, null: false
      add :attribute, :string, null: false
      add :value, :map, null: false
      add :last_event_type, :string
      add :last_event_at, :utc_datetime_usec
      timestamps(updated_at: :updated_at)
    end

    create unique_index(:device_attributes, [:device_id, :attribute])
    create index(:device_attributes, [:device_id])

    create table(:projection_versions, primary_key: false) do
      add :projection_name, :string, primary_key: true
      add :last_seen_event_number, :bigint, null: false
      timestamps(updated_at: :updated_at)
    end
  end
end
