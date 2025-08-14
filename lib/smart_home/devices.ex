defmodule SmartHome.Devices do
  alias SmartHome.App
  alias SmartHome.Devices.Commands.{SetDeviceAttribute, TurnOnDevice, TurnOffDevice}

  def set_attr(device_id, attribute, value) do
    App.dispatch(%SetDeviceAttribute{
      device_id: device_id,
      attribute: attribute,
      value: value
    })
  end

  def turn_on(device_id) do
    App.dispatch(%TurnOnDevice{device_id: device_id})
  end

  def turn_off(device_id) do
    App.dispatch(%TurnOffDevice{device_id: device_id})
  end

  def device_stream(device_id) do
    App |> Commanded.EventStore.stream_forward("device-" <> device_id) |> Enum.to_list()
  end
end
