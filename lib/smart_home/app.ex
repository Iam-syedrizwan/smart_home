defmodule SmartHome.App do
  use Commanded.Application,
    otp_app: :smart_home,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: SmartHome.EventStore
    ],
    pubsub: :local,
    registry: :local

  router(SmartHome.Devices.Router)
end
