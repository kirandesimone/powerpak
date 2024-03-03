defmodule Powerpak.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :cost, :integer
      add :ability, :string
      add :power, :integer
      add :img, :string

      timestamps(type: :utc_datetime)
    end
  end
end
