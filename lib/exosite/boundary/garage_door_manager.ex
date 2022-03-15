defmodule Exosite.Boundary.GarageDoorManager do
  use GenServer
  alias Exosite.Core.GarageDoor
  alias Exosite.Core.GarageDoorEvent
  alias Exosite.Boundary.GarageDoorManager.State

  def new(opts \\ []) do
    fields =
      Keyword.put_new(opts, :door, GarageDoor.new())
      |> Keyword.put_new(:events, [])
      |> Keyword.delete(:name)

    name = Keyword.get(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, State.new(fields), name: name)
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

  def open(name \\ __MODULE__, code, user, now \\ DateTime.utc_now()) do
    GenServer.call(name, {:open, code, user, now})
  end

  def close(name \\ __MODULE__, code, user, now \\ DateTime.utc_now()) do
    GenServer.call(name, {:close, code, user, now})
  end

  def access_code_usage(name \\ __MODULE__, code) do
    GenServer.call(name, {:access_code_usage, code})
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

  @impl true
  def handle_call({:open, code, user, now}, _from, state) do
    event =
      GarageDoorEvent.new(
        user_id: user.id,
        access_code: code,
        created_at: now,
        door_function: &GarageDoor.open(&1, &2)
      )

    state =
      State.add_event(state, event)
      |> State.aggregate_events()

    {:reply, state, state}
  end

  @impl true
  def handle_call({:close, code, user, now}, _from, state) do
    event =
      GarageDoorEvent.new(
        user_id: user.id,
        access_code: code,
        created_at: now,
        door_function: &GarageDoor.close(&1, &2)
      )

    state =
      State.add_event(state, event)
      |> State.aggregate_events()

    {:reply, state, state}
  end

  @impl true
  def handle_call({:access_code_usage, code}, _from, state) do
    count = Enum.count(state.events, &(&1.access_code == code))
    {:reply, count, state}
  end
end

defmodule Exosite.Boundary.GarageDoorManager.State do
  alias Exosite.Core.GarageDoor

  defstruct door: nil, events: []

  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  def update_door(%__MODULE__{} = state, door) do
    Map.put(state, :door, door)
  end

  def add_event(%__MODULE__{} = state, event) do
    events = Enum.concat(state.events, [event])
    Map.put(state, :events, events)
  end

  def aggregate_events(%__MODULE__{door: door, events: events} = state) do
    door = GarageDoor.new(access_codes: door.access_codes)

    door =
      Enum.reduce(events, door, fn event, acc ->
        event.door_function.(acc, event.access_code)
      end)

    update_door(state, door)
  end
end
