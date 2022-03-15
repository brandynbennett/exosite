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
    state = GarageDoorManager.open(code: "abc", user: user)
    assert state.door.state == :open
  end

  test "close/2 closes the door" do
    user = user_fixture()

    door =
      GarageDoor.new(state: :open)
      |> GarageDoor.add_access_code("abc", user)

    GarageDoorManager.new(door: door)
    state = GarageDoorManager.close(code: "abc", user: user)
    assert state.door.state == :closed
  end

  test "access_code_usage/2 counts access code usage" do
    user = user_fixture()

    GarageDoorManager.new()
    GarageDoorManager.add_access_code("abc", user)
    GarageDoorManager.close(code: "abc", user: user)
    GarageDoorManager.open(code: "abc", user: user)
    GarageDoorManager.close(code: "abc", user: user)
    GarageDoorManager.close(code: "foo", user: user)
    GarageDoorManager.open(code: "abc", user: user)
    assert GarageDoorManager.access_code_usage("abc") == 4
  end

  test "door_state/2 returns door state, time in state, and user who put in state" do
    user = user_fixture()

    GarageDoorManager.new()
    GarageDoorManager.add_access_code("abc", user)

    GarageDoorManager.open(
      code: "abc",
      user: user,
      now: DateTime.new!(~D[2022-03-04], ~T[00:00:00])
    )

    assert GarageDoorManager.door_state(DateTime.new!(~D[2022-03-05], ~T[00:00:00])) ==
             {:open, "1 day", user.id}
  end

  test "door_state/2 returns door state no events" do
    user = user_fixture()

    GarageDoorManager.new()
    GarageDoorManager.add_access_code("abc", user)

    assert GarageDoorManager.door_state(DateTime.new!(~D[2022-03-05], ~T[00:00:00])) ==
             {:closed}
  end

  defp user_fixture(overrides \\ []) do
    User.new(Keyword.merge([id: "foo", name: "Jane", email: "jane@exosite.com"], overrides))
  end
end
