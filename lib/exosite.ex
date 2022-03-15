defmodule Exosite do
  alias Exosite.Boundary.GarageDoorManager

  def add_access_code(code, user) do
    GarageDoorManager.new()
    GarageDoorManager.add_access_code(code, user)
  end

  def remove_access_code(code, user) do
    GarageDoorManager.new()
    GarageDoorManager.remove_access_code(code, user)
  end

  def open(code, user) do
    GarageDoorManager.new()
    GarageDoorManager.open(code: code, user: user)
  end

  def close(code, user) do
    GarageDoorManager.new()
    GarageDoorManager.close(code: code, user: user)
  end

  def door_state() do
    GarageDoorManager.new()
    GarageDoorManager.door_state(DateTime.utc_now())
  end
end
