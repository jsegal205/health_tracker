defmodule HealthTracker.Repo.Migrations.AddUserIdToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :user_id, references(:users, type: :uuid)
    end
  end
end
