defmodule LiveTrades.Tradings.Statistic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "statistics" do
    field :price, :float

    belongs_to :company, LiveTrades.Tradings.Company

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(statistic, attrs) do
    statistic
    |> cast(attrs, [:price, :company_id])
    |> validate_required([:price, :company_id])
  end
end
