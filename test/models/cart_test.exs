defmodule PhoenixCommerce.CartTest do
  use PhoenixCommerce.ModelCase

  alias PhoenixCommerce.Cart

  @valid_attrs %{uuid: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
  end
end
