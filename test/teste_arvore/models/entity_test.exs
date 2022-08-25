defmodule TesteArvore.Models.EntityTest do
  use TesteArvore.DataCase, async: true
  alias TesteArvore.Entities.Entity

  describe "changeset/2" do
    test "when valid params returns valid changeset" do
      params = %{
        name: "escola",
        entity_type: "school",
        inep: "123"
      }

      changeset = Entity.changeset(%Entity{}, params)

      assert %Ecto.Changeset{valid?: true} = changeset
    end

    test "when lack params return error" do
      changeset = Entity.changeset(%Entity{}, %{})

      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 name: {"can't be blank", [validation: :required]},
                 entity_type: {"can't be blank", [validation: :required]}
               ]
             } = changeset
    end

    test "when foreign constraint issue with parent_id return error" do
      params = %{
        name: "escola",
        entity_type: "school",
        inep: "123",
        parent_id: 123
      }

      changeset = Entity.changeset(%Entity{}, params)

      result = TesteArvore.Repo.insert(changeset)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  parent_id:
                    {"does not exist",
                     [constraint: :foreign, constraint_name: "entities_parent_id_fkey"]}
                ],
                valid?: false
              }} = result
    end

    test "when entity_type is out of bound returns invalid changeset" do
      params = %{
        name: "escola",
        entity_type: "board",
        inep: "123"
      }

      changeset = Entity.changeset(%Entity{}, params)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 entity_type:
                   {"is invalid", [validation: :inclusion, enum: ["network", "school", "class"]]}
               ]
             } = changeset
    end

    test "when school inep must be provided or returns errors" do
      params = %{
        name: "escola",
        entity_type: "school"
      }

      changeset = Entity.changeset(%Entity{}, params)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 inep: {"Can't be blank when entity_type is school!", [validation: :required]}
               ]
             } = changeset
    end

    test "when class parent_id must be provided or returns errors" do
      params = %{
        name: "escola",
        entity_type: "class"
      }

      changeset = Entity.changeset(%Entity{}, params)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 parent_id: {"Can't be blank when entity_type is class!", [validation: :required]}
               ]
             } = changeset
    end
  end
end
