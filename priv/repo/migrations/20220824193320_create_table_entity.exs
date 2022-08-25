defmodule TesteArvore.Repo.Migrations.CreateTableEntity do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :name, :string, null: false
      add :entity_type, :string, null: false
      add :inep, :string

      timestamps()
    end
  end
end
