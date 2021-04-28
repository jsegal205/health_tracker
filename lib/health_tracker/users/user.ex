defmodule HealthTracker.Users.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  use Pow.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    pow_user_fields()

    timestamps()
  end
end
