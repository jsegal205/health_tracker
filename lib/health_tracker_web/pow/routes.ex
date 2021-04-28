defmodule HealthTrackerWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias HealthTrackerWeb.Router.Helpers, as: Routes

  def after_sign_in_path(conn), do: Routes.category_path(conn, :index)
end
