defmodule TesteArvoreWeb.EntityController do
  use TesteArvoreWeb, :controller
  alias TesteArvore.Entities

  action_fallback TesteArvoreWeb.FallbackController

  def create(conn, params) do
    case Entities.insert_entity(params) do
      {:ok, entity} ->
        conn
        |> put_status(:created)
        |> json(%{data: entity})

      {:error, reason} ->
        {:error, :bad_request, reason}
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Entities.update_entity(id, params) do
      {:ok, entity} ->
        conn
        |> put_status(:ok)
        |> json(%{data: entity})

      {:error, reason} ->
        {:error, :bad_request, reason}
    end
  end

  def show(conn, %{"id" => id}) do
    case Entities.get_entity(id) do
      {:ok, entity} ->
        conn
        |> put_status(:ok)
        |> json(%{data: entity})

      {:error, reason} ->
        {:error, :not_found, reason}
    end
  end
end
