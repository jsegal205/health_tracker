defmodule HealthTracker.Categories.Category do
  @moduledoc """
  Category Schema and changeset
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
  end
end
