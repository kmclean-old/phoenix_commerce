defmodule PhoenixCommerce.Product do
  use PhoenixCommerce.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :price])
    |> validate_required([:name, :description, :price])
  end
end
