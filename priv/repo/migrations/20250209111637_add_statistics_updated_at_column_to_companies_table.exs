defmodule LiveTrades.Repo.Migrations.AddStatisticsUpdatedAtColumnToCompaniesTable do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :statistics_updated_at, :naive_datetime
    end
  end
end
