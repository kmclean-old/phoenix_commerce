defmodule PhoenixCommerce.Product do
  use PhoenixCommerce.Web, :model
  use Arc.Ecto.Schema

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :image, PhoenixCommerce.Image.Type

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :price])
    |> cast_attachments(params, [:image])
    |> validate_required([:name, :description, :price])
  end
end
