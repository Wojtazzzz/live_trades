defmodule LiveTradesWeb.Components.Chart do
  @moduledoc """
  Holds the chart component
  """
  use Phoenix.Component

  attr :id, :string, required: true
  attr :type, :string, default: "line"
  attr :width, :integer, default: nil
  attr :height, :integer, default: nil
  attr :toolbar, :boolean, default: false
  attr :animations, :map, default: false
  attr :dataset, :list, default: []
  attr :categories, :list, default: []

  def line_graph(assigns) do
    ~H"""
    <div
      id={@id}
      class="[&>div]:mx-auto"
      phx-hook="Chart"
      data-config={
        Jason.encode!(
          trim(%{
            height: @height,
            width: @width,
            type: @type,
            animations: @animations,
            toolbar: %{
              show: @toolbar
            }
          })
        )
      }
      data-series={Jason.encode!(@dataset)}
      data-categories={Jason.encode!(@categories)}
    >
    </div>
    """
  end

  defp trim(map) do
    Map.reject(map, fn {_key, val} -> is_nil(val) || val == "" end)
  end
end
