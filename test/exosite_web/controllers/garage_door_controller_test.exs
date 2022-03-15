defmodule ExositeWeb.PageControllerTest do
  use ExositeWeb.ConnCase

  test "GET /api/door-state", %{conn: conn} do
    conn = get(conn, "/api/door-state")
    assert json_response(conn, 200) == %{"door_state" => "closed"}
  end

  test "POST /api/add-access-code", %{conn: conn} do
    conn = post(conn, "/api/add-access-code", %{code: "abc", user_id: "foo"})
    assert json_response(conn, 200) == "ok"
  end

  test "POST /api/remove-access-code", %{conn: conn} do
    conn = post(conn, "/api/remove-access-code", %{code: "abc", user_id: "foo"})
    assert json_response(conn, 200) == "ok"
  end
end
