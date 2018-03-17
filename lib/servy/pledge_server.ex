defmodule Servy.PledgeServer do

  @name :pledge_server
  def start do
    pid = spawn(__MODULE__, :listen_loop, [])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state \\ []) do
    receive do
      {sender, message} when is_pid(sender) ->
        {response, new_state}= handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)
      :clear -> listen_loop([])
      un_supported ->
        IO.puts "Unsupported message: #{un_supported}"
        listen_loop(state)
    end
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
    call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    call @name, :recent_pledges
  end

  def total_pledges do
    call @name, :total_pledges
  end

  def clear do
    cast @name, :clear
  end

  def call(pid, message) do
    send pid, {self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, message
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
