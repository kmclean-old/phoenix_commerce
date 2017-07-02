defmodule PhoenixCommerce.AcceptanceCase do
  Application.ensure_all_started(:hound)

  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers
      alias PhoenixCommerce.Repo

      import Ecto, only: [build_assoc: 2]
      import Ecto.Query, only: [from: 2]
      import PhoenixCommerce.Router.Helpers
      import PhoenixCommerce.AcceptanceCase

      @endpoint PhoenixCommerce.Endpoint

      hound_session()
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PhoenixCommerce.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixCommerce.Repo, {:shared, self()})
    end

    :ok
  end
end
