defmodule LivrariaPhoenixWeb.CategoriesController do
  use LivrariaPhoenixWeb, :controller

  alias LivrariaPhoenix.Books
  alias LivrariaPhoenix.Books.Category

  plug :load_categories when action in [:index, :show]
  plug :authenticate when action in [:index] #plug da função de auth

  def create(conn, %{"category" => category}) do
    redirect(conn, to: Routes.subcategories_path(conn, :index, category: category))
  end

  def index(conn, _params) do
    changeset = Books.change_category(%Category{})
    render(conn, "index.html", changeset: changeset)#..
  end

  def load_categories(conn, _) do
    assign conn, :categories, Books.list_categories()
  end


    #Verifica se cliente está logado
      defp authenticate(conn, _opts) do
        inspect(conn.assigns.current_customer)
        if conn.assigns.current_customer do
          conn
        else
          conn
          |> put_flash(:error, "Você deve se logar para acessar esta página")
          |> redirect(to: Routes.books_path(conn, :index))
          |> halt()
        end
      end

end
