defmodule SmartHome.Devices.Commands.SetDeviceAttribute do
  @enforce_keys [:device_id, :attribute, :value]
  defstruct [:device_id, :attribute, :value, at: DateTime.utc_now()]
end

defmodule SmartHome.Devices.Commands.TurnOnDevice do
  @enforce_keys [:device_id]
  defstruct [:device_id, at: DateTime.utc_now()]
end

defmodule SmartHome.Devices.Commands.TurnOffDevice do
  @enforce_keys [:device_id]
  defstruct [:device_id, at: DateTime.utc_now()]
end
