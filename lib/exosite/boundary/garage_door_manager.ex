defmodule Exosite.Boundary.GarageDoorManager do
  use GenServer

  def new(name \\ __MODULE__, events \\ []) do
    GenServer.start_link(__MODULE__, events, name: name)
  end

  @impl true
  def init(events \\ []) do
    {:ok, events}
  end
end
