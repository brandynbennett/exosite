defmodule ExositeWeb.GarageDoorController do
  use ExositeWeb, :controller

  def index(conn, _params) do
    state = Exosite.door_state()
    json(conn, state)
  end
end
