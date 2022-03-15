defmodule Exosite.Boundary.GarageDoorManagerTest do
  use ExUnit.Case, async: true

  alias Exosite.Core.GarageDoor
  alias Exosite.Boundary.GarageDoorManager
  alias Exosite.Core.User

  test "new/0 creates new manager with initial state" do
    GarageDoorManager.new()

    state = GarageDoorManager.get_state()
    assert is_pid(Process.whereis(GarageDoorManager))
    assert state.events == []
    assert state.door.state == :closed
  end

  test "add_access_code/2 adds an access code" do
    user = user_fixture()

    GarageDoorManager.new()
    state = GarageDoorManager.add_access_code("abc", user)
    [access_code] = state.door.access_codes

    assert access_code.code == "abc"
  end

  test "remove_access_code/2 removes an access code" do
    user = user_fixture()

    GarageDoorManager.new()
    GarageDoorManager.add_access_code("abc", user)
    state = GarageDoorManager.remove_access_code("abc", user)
    assert [] = state.door.access_codes
  end

  test "open/2 opens the door" do
    user = user_fixture()

    door =
      GarageDoor.new(state: :closed)
      |> GarageDoor.add_access_code("abc", user)

    GarageDoorManager.new(door: door)
    state = GarageDoorManager.open("abc", user)
    assert state.door.state == :open
  end

  test "close/2 closes the door" do
    user = user_fixture()

    door =
      GarageDoor.new(state: :open)
      |> GarageDoor.add_access_code("abc", user)

    GarageDoorManager.new(door: door)
    state = GarageDoorManager.close("abc", user)
    assert state.door.state == :closed
  end

  test "access_code_usage/2 counts access code usage" do
    user = user_fixture()

    GarageDoorManager.new()
    GarageDoorManager.add_access_code("abc", user)
    GarageDoorManager.close("abc", user)
    GarageDoorManager.open("abc", user)
    GarageDoorManager.close("abc", user)
    GarageDoorManager.close("foo", user)
    GarageDoorManager.open("abc", user)
    assert GarageDoorManager.access_code_usage("abc") == 4
  end

  defp user_fixture(overrides \\ []) do
    User.new(Keyword.merge([id: "foo", name: "Jane", email: "jane@exosite.com"], overrides))
  end
end
