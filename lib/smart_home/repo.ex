defmodule SmartHome.Repo do
  use Ecto.Repo,
    otp_app: :smart_home,
    adapter: Ecto.Adapters.Postgres
end
