defmodule PhoenixCommerce.Acceptance.CartTest do
  use PhoenixCommerce.AcceptanceCase

  alias PhoenixCommerce.{Product, LineItem, Repo, Order, Cart}
  import Ecto.Query, only: [from: 2]

  @upload %Plug.Upload{path: Path.relative_to_cwd("test/files/fishing.jpg"),
    filename: "fishing.jpg", content_type: "image/jpg"}

  setup do
    Repo.delete_all(Product)
    Repo.delete_all(LineItem)
    Repo.delete_all(Order)
    Repo.delete_all(Cart)

    {:ok, product} =
      Product.changeset(%Product{}, %{
        name: "Some product",
        description: "Product description",
        price: Decimal.new("25.20"),
        image: @upload
      }) |> Repo.insert

    {:ok, product: product}
  end

  test "/cart - shows an empty cart" do
    navigate_to "/cart"

    assert visible_text(heading()) == "Your cart"
    assert length(line_items()) == 0
  end

  test "adding product to a cart shows product in cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button())
    assert length(line_items()) == 1
    assert visible_text(hd(line_items())) =~ ~r/#{product.name}/
  end

  test "different sessions should have different carts", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button())
    assert length(line_items()) == 1

    change_session_to("second user")
    navigate_to "/cart"
    assert length(line_items()) == 0
  end

  test "removing an item from a cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button())
    assert length(line_items()) == 1
    click(remove_from_cart_button(product))
    assert length(line_items()) == 0
  end

  test "updating a line item's quantity", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button())
    update_quantity(product, 5)
    assert quantity(product) == 5
  end

  test "checking out a cart", %{product: product} do
    navigate_to "/products/#{product.id}"
    click(add_to_cart_button())
    navigate_to "/cart"
    checkout()
    order = get_last_order()
    assert order != nil
    assert hd(order.line_items).quantity == 1
  end

  def heading, do: find_element(:css, "h2")
  def cart, do: find_element(:css, ".cart")
  def cart_table, do: find_within_element(cart(), :css, "table")
  def cart_tbody, do: find_within_element(cart_table(), :css, "tbody")
  def line_items, do: find_all_within_element(cart_tbody(), :css, "tr")

  def add_to_cart_button do
    find_element(:css, "button[type=submit].add-to-cart")
  end

  def remove_from_cart_button(product) do
    product_row(product)
    |> find_within_element(:css, ".remove-from-cart")
  end

  def product_row(product) do
    find_element(:css, "tr.product-#{product.id}")
  end

  def quantity_field(product) do
    product_row(product)
    |> find_within_element(:css, ".quantity")
  end

  def update_quantity(product, count) do
    quantity_field(product)
    |> fill_field(count)

    quantity_field(product)
    |> submit_element
  end

  def quantity(product) do
    {quantity, _} =
      quantity_field(product)
      |> attribute_value(:value)
      |> Integer.parse

    quantity
  end

  def checkout do
    click(checkout_button())
    :timer.sleep(1_000)
    focus_frame("stripe_checkout_app")
    fill_field_by_placeholder("Email", "test@example.com")
    find_element(:css, ".Header-navBack") |> click()
    fill_field_by_placeholder("Card number", "4242424242424242")
    fill_field_by_placeholder("MM / YY", "1020")
    fill_field_by_placeholder("CVC", "123")
    fill_field_by_placeholder("ZIP Code", "12345")
    submit_checkout()
    :timer.sleep(6_000)
  end

  def fill_field_by_placeholder(placeholder, val) do
    find_element(:xpath, "//input[@placeholder='#{placeholder}']")
      |> fill_field(val)
  end

  def checkout_button do
    find_element(:css, "button.stripe-button-el")
  end

  def submit_checkout do
    find_element(:css, "button") |> click()
  end

  def get_last_order do
    query =
      from o in Order,
      order_by: [desc: o.inserted_at],
      preload: [:line_items]

    Repo.one(query)
  end
end
