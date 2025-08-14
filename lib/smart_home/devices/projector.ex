defmodule SmartHome.Devices.Projector do
  use Commanded.Projections.Ecto,
    name: "devices_projection",
    repo: SmartHome.Repo

  import Ecto.Query
  alias SmartHome.Read.{Device, DeviceAttribute}

  alias SmartHome.Devices.Events.{
    DeviceSeen,
    DeviceTurnedOn,
    DeviceTurnedOff,
    DeviceAttributeChanged
  }

  # in projection table we are inserting data
  project(%DeviceSeen{device_id: id, at: at}, _, fn multi ->
    multi
    |> upsert_device(id, set: [last_seen: at])
  end)

  project(%DeviceTurnedOn{device_id: id, at: at}, _, fn multi ->
    upsert_device(multi, id, set: [status: "on", last_seen: at])
  end)

  project(%DeviceTurnedOff{device_id: id, at: at}, _, fn multi ->
    upsert_device(multi, id, set: [status: "off", last_seen: at])
  end)

  project(
    %DeviceAttributeChanged{device_id: id, attribute: attr, value: val, at: at},
    _,
    fn multi ->
      Ecto.Multi.insert(
        multi,
        {:attr, {id, attr}},
        %DeviceAttribute{
          device_id: id,
          attribute: attr,
          value: val,
          last_event_type: "DeviceAttributeChanged",
          last_event_at: at
        },
        on_conflict: [
          set: [
            value: val,
            last_event_type: "DeviceAttributeChanged",
            last_event_at: at,
            updated_at: DateTime.utc_now()
          ]
        ],
        conflict_target: [:device_id, :attribute]
      )
    end
  )

  defp upsert_device(multi, id, set: set) do
    Ecto.Multi.insert(
      multi,
      {:device, id},
      %Device{uuid: id, name: "Device #{id}", status: "off"},
      on_conflict: [set: set ++ [updated_at: DateTime.utc_now()]],
      conflict_target: :id
    )
  end
end
