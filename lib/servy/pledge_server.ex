defmodule Servy.PledgeServer do

  @name :pledge_server
  def start do
    pid = spawn(__MODULE__, :listen_loop, [])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state \\ []) do
    receive do
      {sender, {:create_pledge, name, amount}} ->
        IO.puts "received a message"
        {:ok, id} =send_pledge_to_service(name, amount)
        most_recent_state = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_state]
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        IO.puts("recent pledges")
        send(sender, {:response, state})
        listen_loop(state)
      {sender, :total_pledges} ->
        IO.puts("in total pledges")
        total_pledges = state |> Enum.map(&elem(&1, 1)) |> Enum.sum
        send(sender, {:response, total_pledges})
        listen_loop(state)
      un_supported -> IO.puts "Unsupported message: #{un_supported}"
    end
  end

  def create_pledge(name, amount) do
    call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    call @name, :recent_pledges
  end

  def total_pledges do
    call @name, :total_pledges
  end

  def call(pid, message) do
    send pid, {self(), message}
    receive do {:response, response} -> response end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
