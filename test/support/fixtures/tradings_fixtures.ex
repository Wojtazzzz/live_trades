defmodule LiveTrades.TradingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveTrades.Tradings` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> LiveTrades.Tradings.create_company()

    company
  end
end
