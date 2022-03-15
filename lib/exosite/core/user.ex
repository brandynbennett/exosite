defmodule Exosite.Core.User do
  @moduledoc """
  A user that interacts with Garage Doors
  """
  defstruct id: "", name: "", email: ""

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
