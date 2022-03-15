defmodule Exosite.Boundary.GarageDoorManagerTest do
  use ExUnit.Case, async: true

  alias Exosite.Boundary.GarageDoorManager

  test "new/0 creates new manager" do
    GarageDoorManager.new()

    assert is_pid(Process.whereis(GarageDoorManager))
  end
end
