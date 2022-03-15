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

  def open(%__MODULE__{} = door, code) do
    maybe_update_door(door, code, :open)
  end

  def close(%__MODULE__{} = door, code) do
    maybe_update_door(door, code, :close)
  end

  defp maybe_update_door(door, code, action) do
    if valid_code?(door, code) do
      update_door(door, action)
    else
      door
    end
  end

  defp valid_code?(%__MODULE__{} = door, code) do
    Enum.any?(door.access_codes, &(&1.code == code))
  end

  defp update_door(%__MODULE__{state: :open} = door, :close) do
    Map.put(door, :state, :closed)
  end

  defp update_door(%__MODULE__{state: :closed} = door, :open) do
    Map.put(door, :state, :open)
  end

  defp update_door(%__MODULE__{} = door, _action) do
    door
  end
end
