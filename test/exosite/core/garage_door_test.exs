defmodule Exosite.Core.GarageDoorTest do
  use ExUnit.Case, async: true

  alias Exosite.Core.AccessCode
  alias Exosite.Core.GarageDoor
  alias Exosite.Core.User

  test "add_access_code/2 adds new access code" do
    user = user_fixture()

    %GarageDoor{access_codes: [access_code]} =
      GarageDoor.new()
      |> GarageDoor.add_access_code("abc", user)

    assert %AccessCode{user_id: user.id, code: "abc"} == access_code
  end

  test "add_access_code/2 ignores duplicates" do
    user = user_fixture()

    %GarageDoor{access_codes: [access_code]} =
      GarageDoor.new()
      |> GarageDoor.add_access_code("abc", user)
      |> GarageDoor.add_access_code("abc", user)

    assert %AccessCode{user_id: user.id, code: "abc"} == access_code
  end

  test "remove_access_code/2 removes an access code" do
    user = user_fixture()

    assert %GarageDoor{access_codes: []} =
             GarageDoor.new()
             |> GarageDoor.add_access_code("abc", user)
             |> GarageDoor.remove_access_code("abc", user)
  end

  defp user_fixture(overrides \\ []) do
    User.new(Keyword.merge([id: "foo", name: "Jane", email: "jane@exosite.com"], overrides))
  end
end
