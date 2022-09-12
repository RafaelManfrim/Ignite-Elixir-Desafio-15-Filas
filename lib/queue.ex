defmodule Queue do
  use GenServer

  # Client
  def start_link(initial_stack) when is_list(initial_stack) do
    GenServer.start_link(__MODULE__, initial_stack)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (Callbacks)
  @impl true
  def init(stack) do
    {:ok, stack}
  end

  # SYNC
  @impl true
  def handle_call(:pop, _from, [head]) do
    {:reply, head, []}
  end

  # SYNC
  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  # SYNC
  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  # ASYNC
  @impl true
  def handle_cast({:push, element}, stack) do
    {:noreply, stack ++ [element]}
  end
end
