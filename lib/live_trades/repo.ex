defmodule LiveTrades.Repo do
  use Ecto.Repo,
    otp_app: :live_trades,
    adapter: Ecto.Adapters.SQLite3
end
