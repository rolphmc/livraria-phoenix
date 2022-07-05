defmodule LivrariaPhoenix.Books do

  @moduledoc """
    regras de negócio relacionada ao contexto dos livros
  """

  alias LivrariaPhoenix.Books.{Book, Category, Subcategory, CategoriesBooks}

  alias LivrariaPhoenix.Repo

  # #########################
  #                Categories
  # #########################

      # pag 124 p.phoenix ensina a adcionar multiplos registros

  # ---------------Categories

  def change_category(%Category{} = category, params \\ %{}) do
    Category.changeset(category, params)
  end

  def create_category(category) do
    Repo.insert!(%Category{category: category}, on_conflict: :nothing)
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def get_category(id) do
    Repo.get!(Category, id)
  end

  def list_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end

  # ------------Subcategories
  def change_subcategory(%Subcategory{} = subcategory, params \\ %{}) do
    Subcategory.changeset(subcategory, params)
  end

  def create_subcategory(subcategory, category_id) do
    Repo.insert!(%Subcategory{subcategory: subcategory, category_id: category_id}, on_conflict: :nothing)
  end

  def get_subcategorie(id) do
    Repo.get!(Subcategory, id)
  end

  def get_subcategorie_by(params) do
    Enum.find(list_all_subcategories(), fn map ->
      Enum.all?(%{subcategory: to_string(params)}, fn {key, val} -> Map.get(map, key) == val end)
    end)
  end

  def list_subcategories(id) do
    Subcategory
    |> Subcategory.alphabetical(id)
    |> Repo.all()
  end

  def list_all_subcategories() do
    Subcategory
    |> Subcategory.list_all_subcategories()
    |> Repo.all()
  end

  # ###########################
  #                       Books
  # ###########################

  def books_list do
    Book
    |> Book.list_all_books()
    |> Repo.all()
  end

  def change_book(%Book{} = book, params \\ %{}) do
    Book.changeset(book, params)
  end

  #carrega changeset para estrutura do form de cadastro
  def chageset_load(id) do
    subcategory = get_subcategorie(id)
    category = get_category(subcategory.category_id)

    Book.changeset(%Book{}, %{subcategory_fake: subcategory.subcategory, category_fake: category.category})
  end

  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def get_book(id) do
    Repo.get!(Book, id)
  end

  def get_book_by(params) do
    Enum.find(books_list(), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end)
  end


  def register_books(params) do
    %Book{}
    |> Book.changeset(params)
    |> Repo.insert()
  end

  def register_category_book(map) do

    subcategory_id = get_subcategorie_by(map.subcategory_fake)
    book_id = map.id

    map = %{subcategory_id: subcategory_id, book_id: book_id}

    %CategoriesBooks{}
    |> CategoriesBooks.changeset(map)
    |> Repo.insert()
  end

end
