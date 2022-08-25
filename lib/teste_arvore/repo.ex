defmodule TesteArvore.Repo do
  use Ecto.Repo,
    otp_app: :teste_arvore,
    adapter: Ecto.Adapters.MyXQL
end
