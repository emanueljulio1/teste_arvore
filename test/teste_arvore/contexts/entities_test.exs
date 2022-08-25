defmodule TesteArvore.Contexts.EntitiesTest do
  use TesteArvore.DataCase, async: true
  alias TesteArvore.{Entities, Repo}
  alias TesteArvore.Entities.Entity

  describe "get_entity/1" do
    test "when entity exists returns okay" do
      entity = Repo.insert!(%Entity{name: "escola", entity_type: "school", inep: "123"})

      result = Entities.get_entity(entity.id)

      assert {:ok, _entity} = result
    end

    test "when entity does not exist returns error" do
      result = Entities.get_entity(1)

      assert {:error, "Not found!"} = result
    end
  end

  describe "insert_entity/1" do
    test "when valid params returns okay" do
      result = Entities.insert_entity(%{name: "escola", entity_type: "school", inep: "123"})

      assert {:ok, _entity} = result
    end

    test "when invalid params returns error" do
      result =
        Entities.insert_entity(%{
          name: "escola",
          entity_type: "school",
          inep: "123",
          parent_id: 123
        })

      assert {:error, _reason} = result
    end
  end

  describe "update_entity/2" do
    test "when valid params returns okay" do
      entity = Repo.insert!(%Entity{name: "escola", entity_type: "school", inep: "123"})

      result = Entities.update_entity(entity.id, %{name: "rede de escolas"})

      assert {:ok, %Entity{name: "rede de escolas"}} = result
    end

    test "when invalid params returns error" do
      entity = Repo.insert!(%Entity{name: "escola", entity_type: "school", inep: "123"})

      result = Entities.update_entity(entity.id, %{parent_id: 123})

      assert {:error, _reason} = result
    end
  end
end
