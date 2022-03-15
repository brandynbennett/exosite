defmodule Exosite.Boundary.GarageDoorManager do
  use GenServer
  alias Exosite.Core.GarageDoor
  alias Exosite.Boundary.GarageDoorManager.State

  def new(name \\ __MODULE__, events \\ []) do
    GenServer.start_link(__MODULE__, State.new(events: events), name: name)
  end

  def get_state(name \\ __MODULE__) do
    GenServer.call(name, :get_state)
  end

  def add_access_code(name \\ __MODULE__, code, user) do
    GenServer.call(name, {:add_access_code, code, user})
  end

  def remove_access_code(name \\ __MODULE__, code, user) do
    GenServer.call(name, {:remove_access_code, code, user})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:add_access_code, code, user}, _from, state) do
    door = GarageDoor.add_access_code(state.door, code, user)
    state = State.update_door(state, door)
    {:reply, state, state}
  end

  @impl true
  def handle_call({:remove_access_code, code, user}, _from, state) do
    door = GarageDoor.remove_access_code(state.door, code, user)
    state = State.update_door(state, door)
    {:reply, state, state}
  end
end

defmodule Exosite.Boundary.GarageDoorManager.State do
  alias Exosite.Core.GarageDoor

  defstruct door: nil, events: []

  def new(fields \\ []) do
    fields = Keyword.put_new(fields, :door, GarageDoor.new())
    struct!(__MODULE__, fields)
  end

  def update_door(%__MODULE__{} = state, door) do
    Map.put(state, :door, door)
  end
end
