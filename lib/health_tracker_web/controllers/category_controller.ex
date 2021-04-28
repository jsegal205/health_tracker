defmodule HealthTrackerWeb.CategoryController do
  use HealthTrackerWeb, :controller

  alias HealthTracker.Categories
  alias HealthTracker.Categories.Category

  def index(conn, _params) do
    categories = Categories.list_categories(conn.assigns.current_user.id)
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Categories.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    current_user = conn.assigns.current_user
    changeset = Map.put(category_params, "user_id", current_user.id)

    case Categories.create_category(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Categories.get_category(id, conn.assigns.current_user.id) do
      nil ->
        render_not_found(conn)

      category ->
        render(conn, "show.html", category: category)
    end
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    case Categories.get_category(id, conn.assigns.current_user.id) do
      nil ->
        render_not_found(conn)

      category ->
        changeset = Categories.change_category(category)
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    case Categories.get_category(id, conn.assigns.current_user.id) do
      nil ->
        render_not_found(conn)

      category ->
        case Categories.update_category(category, category_params) do
          {:ok, updated_category} ->
            conn
            |> put_flash(:info, "Category updated successfully.")
            |> redirect(to: Routes.category_path(conn, :show, updated_category))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", category: category, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Categories.get_category(id, conn.assigns.current_user.id) do
      nil ->
        render_not_found(conn)

      category ->
        Categories.delete_category(category)

        conn
        |> put_flash(:info, "Category deleted successfully.")
        |> redirect(to: Routes.category_path(conn, :index))
    end
  end

  defp render_not_found(conn) do
    conn
    |> put_status(404)
    |> put_view(HealthTrackerWeb.ErrorView)
    |> render("404.html")
  end
end
