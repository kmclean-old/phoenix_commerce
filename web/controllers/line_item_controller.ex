defmodule PhoenixCommerce.LineItemController do
  use PhoenixCommerce.Web, :controller

  alias PhoenixCommerce.LineItem

  def delete(conn, %{"id" => id}) do
    line_item = Repo.get!(LineItem, id)

    Repo.delete!(line_item)

    conn
    |> put_flash(:info, "Line Item removed from cart successfully.")
    |> redirect(to: cart_path(conn, :show))
  end
end
