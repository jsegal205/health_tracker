defmodule HealthTrackerWeb.PageController do
  use HealthTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
