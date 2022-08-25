defmodule TesteArvore.Entities.Entity do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  @derive {Jason.Encoder, only: [:name, :entity_type, :inep, :parent_id, :subtree_ids]}

  schema "entities" do
    field :name, :string
    field :entity_type, :string
    field :inep, :string
    field :parent_id, :id
    field :subtree_ids, :map, virtual: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :entity_type, :inep, :parent_id])
    |> validate_required([:name, :entity_type])
    |> foreign_key_constraint(:parent_id)
    |> validate_inclusion(:entity_type, ["network", "school", "class"])
    |> validate_inep()
    |> validate_parent_id()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :entity_type, :inep, :parent_id])
    |> foreign_key_constraint(:parent_id)
    |> validate_inclusion(:entity_type, ["network", "school", "class"])
    |> validate_inep()
    |> validate_parent_id()
  end

  defp validate_inep(
         %Ecto.Changeset{valid?: true, changes: %{entity_type: "school"} = changes} = changeset
       ) do
    case Map.has_key?(changes, :inep) do
      true ->
        changeset

      false ->
        add_error(changeset, :inep, "Can't be blank when entity_type is school!",
          validation: :required
        )
    end
  end

  defp validate_inep(changeset), do: changeset

  defp validate_parent_id(
         %Ecto.Changeset{valid?: true, changes: %{entity_type: "class"} = changes} = changeset
       ) do
    case Map.has_key?(changes, :parent_id) do
      true ->
        changeset

      false ->
        add_error(changeset, :parent_id, "Can't be blank when entity_type is class!",
          validation: :required
        )
    end
  end

  defp validate_parent_id(changeset), do: changeset
end
