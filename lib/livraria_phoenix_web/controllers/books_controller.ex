defmodule LivrariaPhoenixWeb.BooksController do
  use LivrariaPhoenixWeb, :controller

  alias LivrariaPhoenix.Books

  def index(conn, _params) do
    books = Books.books_list()
    render(conn, "index.html", books: books)
  end

end