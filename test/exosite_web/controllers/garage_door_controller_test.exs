defmodule ExositeWeb.PageControllerTest do
  use ExositeWeb.ConnCase

  test "GET /api/door-state", %{conn: conn} do
    conn = get(conn, "/api/door-state")
    assert json_response(conn, 200) == %{"door_state" => "closed"}
  end
end
