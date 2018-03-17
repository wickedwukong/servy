defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct [cache_size: 3, pledges: []]
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
     {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, cache_size}, state) do
   {:noreply, %{state | cache_size: cache_size}}
  end


  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} =send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    new_state = %{state | pledges: [{name, amount} | most_recent_pledges]}
    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledges, _from, state) do
    total_pledges = state.pledges |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {:reply, total_pledges, state}
  end

  def handle_info(message, state) do
    IO.puts "Unsupported message: #{inspect message}"
    {:noreply, state}
  end

  def set_cache_size(cache_size) when cache_size >= 0 do
     GenServer.cast @name, {:set_cache_size, cache_size}
  end
  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledges do
    GenServer.call @name, :total_pledges
  end

  def clear do
    GenServer.cast @name, :clear
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do

    [{"Tom", 100}, {"Xuemin", 200}]
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()
#
# # send pid, {:stop, "hammertime"}
#
# IO.inspect PledgeServer.create_pledge("larry", 10)
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)

# #PledgeServer.clear()

# IO.inspect PledgeServer.create_pledge("grace", 50)

# IO.inspect PledgeServer.recent_pledges()

# IO.inspect PledgeServer.total_pledges()
