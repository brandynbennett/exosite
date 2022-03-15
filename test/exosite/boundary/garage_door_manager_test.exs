defmodule Exosite.Boundary.GarageDoorManagerTest do
  use ExUnit.Case, async: true

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

  defp user_fixture(overrides \\ []) do
    User.new(Keyword.merge([id: "foo", name: "Jane", email: "jane@exosite.com"], overrides))
  end
end
