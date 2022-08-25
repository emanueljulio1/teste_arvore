defmodule TesteArvore.Entities do
  import Ecto.Query

  alias TesteArvore.Entities.Entity
  alias TesteArvore.Repo

  def get_entity(id) do
    entity = Repo.get(Entity, id)

    case entity do
      nil -> {:error, "Not found!"}
      entity -> {:ok, Map.put(entity, :subtree_ids, get_children(id))}
    end
  end

  def insert_entity(params) do
    changeset = Entity.changeset(%Entity{}, params)

    case Repo.insert(changeset) do
      {:ok, entity} ->
        {:ok, Map.put(entity, :subtree_ids, [])}

      error ->
        error
    end
  end

  def update_entity(id, params) do
    with {:ok, entity} <- get_entity(id),
         %Ecto.Changeset{valid?: true} = changeset <- Entity.update_changeset(entity, params),
         {:ok, new_entity} <- Repo.update(changeset) do
      {:ok, Map.put(new_entity, :subtree_ids, get_children(id))}
    else
      {:error, reason} -> {:error, reason}
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end

  defp get_children(id) do
    query =
      from p in Entity,
        where: p.parent_id == ^id,
        select: p.id

    Repo.all(query)
  end
end
