defmodule LiveTrades.TradingClient do
  def fetch_company_data_by_code(code) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(
             "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{String.upcase(code)}&apikey=0UK6V2NVUXRJ1JDX"
           ),
         {:ok, data} = Jason.decode(body) do
      global_quote = Map.get(data, "Global Quote", %{})

      IO.inspect(data)

      %{
        price: Map.get(global_quote, "05. price", "N/A"),
        symbol: Map.get(global_quote, "01. symbol", "N/A"),
        change: Map.get(global_quote, "09. change", "N/A"),
        open: Map.get(global_quote, "02. open", "N/A")
      }
    else
      _ -> {:error, :failed_to_fetch_data}
    end
  end
end
