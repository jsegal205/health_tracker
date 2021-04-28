defmodule HealthTrackerWeb.CategoryControllerTest do
  use HealthTrackerWeb.ConnCase

  alias HealthTracker.{Categories, Repo, Users.User}

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:category) do
    user = Repo.all(User) |> hd
    attrs = Enum.into(@create_attrs, %{user_id: user.id})

    {:ok, category} = Categories.create_category(attrs)
    category
  end

  setup %{conn: conn} do
    user =
      %User{}
      |> User.changeset(%{
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      })
      |> Repo.insert!()

    authed_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all categories", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.category_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Categories"
    end
  end

  describe "new category" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.category_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn =
        post(authed_conn, Routes.category_path(authed_conn, :create), category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.category_path(authed_conn, :show, id)

      conn = get(authed_conn, Routes.category_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Category"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn =
        post(authed_conn, Routes.category_path(authed_conn, :create), category: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "edit category" do
    setup [:create_category]

    test "renders form for editing chosen category", %{
      authed_conn: authed_conn,
      category: category
    } do
      conn = get(authed_conn, Routes.category_path(authed_conn, :edit, category))
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{authed_conn: authed_conn, category: category} do
      conn =
        put(authed_conn, Routes.category_path(authed_conn, :update, category),
          category: @update_attrs
        )

      assert redirected_to(conn) == Routes.category_path(authed_conn, :show, category)

      conn = get(authed_conn, Routes.category_path(authed_conn, :show, category))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, category: category} do
      conn =
        put(authed_conn, Routes.category_path(authed_conn, :update, category),
          category: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{authed_conn: authed_conn, category: category} do
      conn = delete(authed_conn, Routes.category_path(authed_conn, :delete, category))
      assert redirected_to(conn) == Routes.category_path(conn, :index)

      conn = get(authed_conn, Routes.category_path(authed_conn, :show, category))
      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  defp create_category(_) do
    category = fixture(:category)
    %{category: category}
  end
end
