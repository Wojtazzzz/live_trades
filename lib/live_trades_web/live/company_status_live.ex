defmodule LiveTradesWeb.CompanyStatusLive do
  alias LiveTrades.Tradings
  use LiveTradesWeb, :live_view
  import LiveTradesWeb.Components.Chart

  @refresh_time 1_000 * 60 * 3

  def render(assigns) do
    ~H"""
    <div class="w-full bg-white p-8 rounded-xl shadow">
      <hgroup class="space-y-3 mb-3">
        <h1 class="text-3xl text-[#05004E] font-semibold">{@company.name}</h1>
        <p class="text-xl font-medium">
          {List.first(@company.statistics, %{price: 0}).price} USD
        </p>
      </hgroup>

      <.line_graph
        id="chart"
        height={420}
        width="100%"
        dataset={[
          %{
            name: "",
            data: @reversed_stats |> Enum.map(& &1.price)
          }
        ]}
        categories={
          @reversed_stats
          |> Enum.map(&Calendar.strftime(&1.inserted_at, "%H:%M"))
        }
        animations={
          %{
            enabled: true,
            speed: 800,
            animateGradually: %{
              enabled: true,
              delay: 150
            },
            dynamicAnimation: %{
              enabled: true,
              speed: 350
            }
          }
        }
      />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Process.send_after(self(), :new_data, @refresh_time)

    company = Tradings.get_company_with_data(1)
    reversed_stats = Enum.reverse(company.statistics)

    {:ok,
     assign(
       socket,
       page_title: company.name,
       company: company,
       reversed_stats: reversed_stats
     )}
  end

  def handle_info(:new_data, socket) do
    Process.send_after(self(), :new_data, @refresh_time)

    # push only new data instead of whole bunch after migrating to premium API
    company = Tradings.get_company_with_data(1)
    reversed_stats = Enum.reverse(company.statistics)

    {:noreply,
     push_event(socket, "new_data", %{
       dataset: [
         %{
           name: "",
           data:
             reversed_stats
             |> Enum.map(& &1.price)
         }
       ],
       categories:
         reversed_stats
         |> Enum.map(&Calendar.strftime(&1.inserted_at, "%H:%M"))
     })}
  end
end
