defmodule LiveTradesWeb.Components.CompanyTiles do
  @moduledoc """
  Holds the company tiles component
  """
  use Phoenix.Component

  attr :name, :string, required: true
  attr :code, :string, required: true
  attr :price, :float, default: nil

  def tile(assigns) do
    ~H"""
    <div class="w-full bg-white p-8 rounded-xl shadow">
      <p class="text-2xl text-[#05004E] font-semibold">{@name}</p>
      <p class="text-sm font-medium text-black/50">
        {String.upcase(@code)}
      </p>
      <p class="font-medium">
        {@price} USD
      </p>
    </div>
    """
  end
end
