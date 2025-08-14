defmodule SmartHome.Read.Device do
  use Ecto.Schema
  @primary_key {:uuid, :binary_id, []}
  schema "devices" do
    field :name, :string
    field :status, :string
    field :last_seen, :utc_datetime_usec
    timestamps()
  end
end

defmodule SmartHome.Read.DeviceAttribute do
  use Ecto.Schema

  schema "device_attributes" do
    field :device_id, :binary_id
    field :attribute, :string
    field :value, :map
    field :last_event_type, :string
    field :last_event_at, :utc_datetime_usec
    timestamps(updated_at: :updated_at)
  end
end
