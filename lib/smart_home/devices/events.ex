defmodule SmartHome.Devices.Events.DeviceAttributeChanged do
  @derive Jason.Encoder
  defstruct [:device_id, :attribute, :value, :at]
end

defmodule SmartHome.Devices.Events.DeviceTurnedOn do
  @derive Jason.Encoder
  defstruct [:device_id, :at]
end

defmodule SmartHome.Devices.Events.DeviceTurnedOff do
  @derive Jason.Encoder
  defstruct [:device_id, :at]
end

defmodule SmartHome.Devices.Events.DeviceSeen do
  @derive Jason.Encoder
  defstruct [:device_id, :at]
end
