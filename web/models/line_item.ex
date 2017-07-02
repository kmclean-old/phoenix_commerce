defmodule PhoenixCommerce.LineItem do
  use PhoenixCommerce.Web, :model

  schema "line_items" do
    field :quantity, :integer
    belongs_to :product, PhoenixCommerce.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
