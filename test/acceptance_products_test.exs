defmodule PhoenixCommerce.Acceptance.ProductsTest do
  use PhoenixCommerce.AcceptanceCase

  test "/products has a list of products" do
    navigate_to "/products"
    assert find_element(:css, "ul.products")
  end
end
