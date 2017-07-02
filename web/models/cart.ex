defmodule PhoenixCommerce.Cart do
  use PhoenixCommerce.Web, :model

  schema "carts" do
    field :uuid, Ecto.UUID, autogenerate: true
    has_many :line_items, PhoenixCommerce.LineItem

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid])
  end
end
