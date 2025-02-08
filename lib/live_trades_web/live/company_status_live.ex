defmodule LiveTradesWeb.CompanyStatusLive do
  alias LiveTrades.Tradings
  use LiveTradesWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <div>{@company.name}</div>
      <div>20 PLN</div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    company = Tradings.get_company_by_code("aapl")
    data = Tradings.get_company_current_data(company.code)

    IO.inspect(data)

    temperature = 70
    {:ok, assign(socket, temperature: temperature, company: company)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
