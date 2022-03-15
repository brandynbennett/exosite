defmodule Exosite.Core.GarageDoor do
  @moduledoc """
  Rerepesents a Garage Door
  """
  alias Exosite.Core.AccessCode
  alias Exosite.Core.User

  defstruct state: :closed, access_codes: []

  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  def add_access_code(%__MODULE__{} = door, code, %User{} = user) do
    codes =
      Enum.concat(door.access_codes, [AccessCode.new(code: code, user_id: user.id)])
      |> Enum.dedup()

    Map.put(door, :access_codes, codes)
  end

  def remove_access_code(%__MODULE__{} = door, code, %User{} = user) do
    codes = List.delete(door.access_codes, AccessCode.new(code: code, user_id: user.id))
    Map.put(door, :access_codes, codes)
  end
end
