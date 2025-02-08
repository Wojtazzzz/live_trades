defmodule LiveTrades.Repo.Migrations.CreateStatistics do
  use Ecto.Migration

  def change do
    create table(:statistics) do
      add :price, :float

      add :company_id, references(:companies)

      timestamps(type: :utc_datetime)
    end
  end
end
