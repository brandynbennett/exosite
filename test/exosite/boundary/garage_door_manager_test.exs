defmodule Exosite.Boundary.GarageDoorManagerTest do
  use ExUnit.Case, async: true

  alias Exosite.Boundary.GarageDoorManager

  test "new/0 creates new manager with initial state" do
    GarageDoorManager.new()

    state = GarageDoorManager.get_state()
    assert is_pid(Process.whereis(GarageDoorManager))
    assert state.events == []
    assert state.door.state == :closed
  end

  test "" do
  end
end
