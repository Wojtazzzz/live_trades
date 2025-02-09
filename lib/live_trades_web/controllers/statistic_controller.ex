defmodule LiveTradesWeb.StatisticController do
  alias LiveTrades.Tradings
  use LiveTradesWeb, :controller

  def create(conn, _params) do
    Tradings.update_next_companies()

    json(conn, %{
      status: "ok"
    })
  end
end
