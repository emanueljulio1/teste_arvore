defmodule TesteArvoreWeb.FallbackController do
  use TesteArvoreWeb, :controller
  alias TesteArvoreWeb.ErrorView

  def call(conn, {:error, status, result}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
