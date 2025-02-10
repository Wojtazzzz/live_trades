defmodule LiveTrades.TradingClient do
  def fetch_company_data_by_code(code) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(
             "https://api.twelvedata.com/price?symbol=#{code}&apikey=#{System.get_env("ALPHA_VANTAGE_API_KEY")}"
           ),
         {:ok, data} = Jason.decode(body) do
      Map.get(data, "price", "N/A")
    else
      _ -> {:error, :failed_to_fetch_data}
    end
  end
end
