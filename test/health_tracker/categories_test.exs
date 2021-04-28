defmodule HealthTracker.CategoriesTest do
  use HealthTracker.DataCase
  use ExUnit.Case, async: true

  alias HealthTracker.{Repo, Categories, Categories.Category, Users.User}

  describe "categories" do
    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}
    @password "password123"

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Categories.create_category()

      category
    end

    def create_user(email \\ "test@example.com") do
      %User{}
      |> User.changeset(%{
        email: email,
        password: @password,
        password_confirmation: @password
      })
      |> Repo.insert!()
    end

    test "list_categories/0 returns all categories" do
      user = create_user()
      user2 = create_user("test2@example.com")
      category = category_fixture(%{user_id: user.id})
      assert Categories.list_categories(user.id) == [category]
      assert Categories.list_categories(user2.id) == []
    end

    test "get_category/1 returns the category with given id" do
      user = create_user()
      category = category_fixture(%{user_id: user.id})

      assert Categories.get_category(category.id, user.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      user = create_user()
      attrs = Enum.into(@valid_attrs, %{user_id: user.id})

      assert {:ok, %Category{} = category} = Categories.create_category(attrs)
      assert category.title == "some title"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categories.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      user = create_user()
      category = category_fixture(%{user_id: user.id})

      assert {:ok, %Category{} = category} = Categories.update_category(category, @update_attrs)
      assert category.title == "some updated title"
    end

    test "update_category/2 with invalid data returns error changeset" do
      user = create_user()
      category = category_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} = Categories.update_category(category, @invalid_attrs)
      assert category == Categories.get_category(category.id, user.id)
    end

    test "delete_category/1 deletes the category" do
      user = create_user()
      category = category_fixture(%{user_id: user.id})

      assert {:ok, %Category{}} = Categories.delete_category(category)
      assert is_nil(Categories.get_category(category.id, user.id))
    end

    test "change_category/1 returns a category changeset" do
      user = create_user()
      category = category_fixture(%{user_id: user.id})

      assert %Ecto.Changeset{} = Categories.change_category(category)
    end
  end
end
