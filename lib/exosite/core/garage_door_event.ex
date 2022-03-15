defmodule Exosite.Core.GarageDoorEvent do
  @moduledoc """
  Events that a user does to a GarageDoor
  """
  defstruct user_id: nil, access_code: nil, created_at: nil, door_function: nil

  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end
end
