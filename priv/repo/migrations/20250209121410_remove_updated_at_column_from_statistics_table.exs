defmodule LiveTrades.Repo.Migrations.RemoveUpdatedAtColumnFromStatisticsTable do
  use Ecto.Migration

  def change do
    alter table(:statistics) do
      remove :updated_at
    end
  end
end
