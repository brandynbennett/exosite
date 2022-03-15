defmodule ExositeWeb.GarageDoorController do
  use ExositeWeb, :controller

  alias Exosite.Core.User

  def index(conn, _params) do
    state = Exosite.door_state()
    json(conn, state)
  end

  def add_access_code(conn, %{"code" => code, "user_id" => user_id}) do
    Exosite.add_access_code(code, User.new(id: user_id))
    json(conn, :ok)
  end

  def remove_access_code(conn, %{"code" => code, "user_id" => user_id}) do
    Exosite.remove_access_code(code, User.new(id: user_id))
    json(conn, :ok)
  end

  def open(conn, %{"code" => code, "user_id" => user_id}) do
    Exosite.open(code, User.new(id: user_id))
    json(conn, :ok)
  end

  def close(conn, %{"code" => code, "user_id" => user_id}) do
    Exosite.close(code, User.new(id: user_id))
    json(conn, :ok)
  end
end
