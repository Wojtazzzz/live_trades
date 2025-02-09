defmodule LiveTrades.Tradings.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :code, :string
    field :name, :string
    field :statistics_updated_at, :naive_datetime

    has_many :statistics, LiveTrades.Tradings.Statistic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :code, :statistics_updated_at])
    |> validate_required([:name, :code])
  end
end
