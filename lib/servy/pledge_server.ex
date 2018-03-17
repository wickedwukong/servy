defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  def start do
    GenServer.start(__MODULE__, [], name: @name)
  end

  def handle_cast(:clear, _state) do
     {:noreply, []}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} =send_pledge_to_service(name, amount)
    most_recent_state = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_state]
    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:total_pledges, _from, state) do
    total_pledges = state |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {:reply, total_pledges, state}
  end

  def handle_call(un_supported, _from, state) do
    {"Unsupported message: #{un_supported}", state}
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
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()
#
# send pid, {:stop, "hammertime"}
#
# IO.inspect PledgeServer.create_pledge("larry", 10)
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)

# #PledgeServer.clear()

# IO.inspect PledgeServer.create_pledge("grace", 50)

# IO.inspect PledgeServer.recent_pledges()

# IO.inspect PledgeServer.total_pledges()
