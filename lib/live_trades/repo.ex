defmodule LiveTrades.Repo do
  use Ecto.Repo,
    otp_app: :live_trades,
    adapter: Ecto.Adapters.Postgres
end
