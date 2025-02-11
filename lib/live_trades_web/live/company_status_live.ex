defmodule LiveTradesWeb.CompanyStatusLive do
  alias LiveTrades.Tradings
  use LiveTradesWeb, :live_view
  import LiveTradesWeb.Components.Chart
  import LiveTradesWeb.Components.CompanyTiles

  # @refresh_time 1_000 * 60 * 3
  @refresh_time 5_000

  def render(assigns) do
    ~H"""
    <div class="space-y-5">
      <div class="flex flex-col sm:flex-row gap-5">
        <%= for company <- @companies do %>
          <.link patch={~p"/#{company.id}"} class="w-full">
            <.tile name={company.name} code={company.code} price={company.name} />
          </.link>
        <% end %>
      </div>

      <div class="w-full bg-white p-8 rounded-xl shadow">
        <hgroup class="space-y-3 mb-3">
          <h1 class="text-3xl text-[#05004E] font-semibold">{@company.name}</h1>
          <p class="text-xl font-medium">
            {List.first(@company.statistics, %{price: 0}).price} USD
          </p>
        </hgroup>

        <div class="min-h-[420px]">
          <.line_graph
            id="chart"
            height={420}
            width="100%"
            dataset={[
              %{
                name: "",
                data: @dataset
              }
            ]}
            categories={@categories}
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
      </div>
    </div>
    """
  end

  def mount(%{"id" => company_id}, _session, socket) do
    Process.send_after(self(), :new_data, @refresh_time)

    %{
      company: company,
      dataset: dataset,
      categories: categories
    } = get_company_data(company_id)

    companies = Tradings.list_companies()

    {:ok,
     assign(
       socket,
       page_title: company.name,
       company: company,
       companies: companies,
       categories: categories,
       dataset: dataset
     )}
  end

  def handle_info(:new_data, socket) do
    Process.send_after(self(), :new_data, @refresh_time)

    %{
      company: company,
      dataset: dataset,
      categories: categories
    } = get_company_data(socket.assigns.company.id)

    {:noreply,
     push_event(
       assign(
         socket,
         company: company
       ),
       "new_data",
       %{
         dataset: [
           %{
             name: "",
             data: dataset
           }
         ],
         categories: categories
       }
     )}
  end

  def handle_params(%{"id" => company_id}, _uri, socket) do
    %{
      company: company,
      dataset: dataset,
      categories: categories
    } = get_company_data(company_id)

    {:noreply,
     push_event(
       assign(
         socket,
         page_title: company.name,
         company: company,
         categories: categories,
         dataset: dataset
       ),
       "new_data",
       %{
         dataset: [
           %{
             name: "",
             data: dataset
           }
         ],
         categories: categories
       }
     )}
  end

  defp get_company_data(company_id) do
    company = Tradings.get_company_with_data(company_id)
    reversed_stats = Enum.reverse(company.statistics)

    dataset =
      reversed_stats
      |> Enum.map(& &1.price)

    categories =
      reversed_stats
      |> Enum.map(&Calendar.strftime(&1.inserted_at, "%H:%M"))

    %{
      company: company,
      dataset: dataset,
      categories: categories
    }
  end
end
