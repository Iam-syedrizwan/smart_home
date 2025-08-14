defmodule SmartHome.Devices.DeviceAgg do
  defstruct device_id: nil, status: "off", attrs: %{}, last_seen: nil

  alias SmartHome.Devices.Commands.{SetDeviceAttribute, TurnOnDevice, TurnOffDevice}

  alias SmartHome.Devices.Events.{
    DeviceAttributeChanged,
    DeviceTurnedOn,
    DeviceTurnedOff,
    DeviceSeen
  }

  # Execute (validate business rules → emit events)
  # in execute -> %DeviceAgg{}, commond_struct
  def execute(%__MODULE__{device_id: nil}, %SetDeviceAttribute{
        device_id: id,
        attribute: attr,
        value: value
      }) do
    [
      %DeviceSeen{device_id: id, at: DateTime.utc_now()},
      %DeviceAttributeChanged{
        device_id: id,
        attribute: attr,
        value: value,
        at: DateTime.utc_now()
      }
    ]
  end

  def execute(%__MODULE__{}, %SetDeviceAttribute{device_id: id, attribute: attr, value: value}) do
    [
      %DeviceAttributeChanged{
        device_id: id,
        attribute: attr,
        value: value,
        at: DateTime.utc_now()
      }
    ]
  end

  def execute(%__MODULE__{status: "on"}, %TurnOnDevice{}), do: []

  def execute(%__MODULE__{}, %TurnOnDevice{device_id: id}) do
    [%DeviceTurnedOn{device_id: id, at: DateTime.utc_now()}]
  end

  def execute(%__MODULE__{status: "off"}, %TurnOffDevice{}), do: []

  def execute(%__MODULE__{}, %TurnOffDevice{device_id: id}) do
    [%DeviceTurnedOff{device_id: id, at: DateTime.utc_now()}]
  end

  # Apply (mutate in-memory state)
  # in apply() -> %DeviceAgg{}, event_struct, we set event_struct in execute time
  def apply(%__MODULE__{} = state, %DeviceSeen{at: at, device_id: id}) do
    %__MODULE__{state | device_id: id, last_seen: at}
  end

  def apply(%__MODULE__{} = state, %DeviceAttributeChanged{attribute: attrs, value: value}) do
    %__MODULE__{state | attrs: Map.put(state.attrs, attrs, value)}
  end

  def apply(%__MODULE__{} = state, %DeviceTurnedOn{}) do
    %__MODULE__{state | status: "on"}
  end

  def apply(%__MODULE__{} = state, %DeviceTurnedOff{}) do
    %__MODULE__{state | status: "off"}
  end
end
