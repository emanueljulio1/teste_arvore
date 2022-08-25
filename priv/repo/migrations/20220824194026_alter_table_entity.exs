defmodule TesteArvore.Repo.Migrations.AlterTableEntity do
  use Ecto.Migration

  def change do
    alter table(:entities) do
      add :parent_id, references(:entities)
    end
  end
end
