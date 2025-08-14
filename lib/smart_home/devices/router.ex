defmodule SmartHome.Devices.Router do
  use Commanded.Commands.Router

  alias SmartHome.Devices.DeviceAgg
  alias SmartHome.Devices.Commands.{SetDeviceAttribute, TurnOnDevice, TurnOffDevice}

  identify(DeviceAgg, by: :device_id, prefix: "device-")

  dispatch([SetDeviceAttribute, TurnOnDevice, TurnOffDevice],
    to: DeviceAgg,
    identity: :device_id
  )
end
