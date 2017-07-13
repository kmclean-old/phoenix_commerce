defmodule PhoenixCommerce.Order do
  use PhoenixCommerce.Web, :model

  schema "orders" do
    has_many :line_items, PhoenixCommerce.LineItem
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
