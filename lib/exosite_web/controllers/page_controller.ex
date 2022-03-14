defmodule ExositeWeb.PageController do
  use ExositeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
