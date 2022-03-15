defmodule Exosite.Core.AccessCode do
  defstruct user_id: nil, code: nil

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
