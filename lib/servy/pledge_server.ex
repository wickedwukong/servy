defmodule Servy.GenericServer do

  def start(callback, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback])
    Process.register(pid, name)
    pid
  end

  def listen_loop(state, callback) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state}= callback.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback)
      {:cast, message} ->
        new_state = callback.handle_cast(message, state)
        listen_loop(new_state, callback)
      un_supported ->
        IO.puts "Unsupported message: #{inspect un_supported}"
        listen_loop(state, callback)
    end
  end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end
end

defmodule Servy.PledgeServer do
  alias Servy.GenericServer

  @name :pledge_server

  def start do
    GenericServer.start(__MODULE__, [], @name)
  end

  def handle_cast(:clear, _state) do
     []
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} =send_pledge_to_service(name, amount)
    most_recent_state = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_state]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledges, state) do
    total_pledges = state |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {total_pledges, state}
  end

  def handle_call(un_supported, state) do
    {"Unsupported message: #{un_supported}", state}
  end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledges do
    GenericServer.call @name, :total_pledges
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()
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

# IO.inspect PledgeServer.total_pledged()
