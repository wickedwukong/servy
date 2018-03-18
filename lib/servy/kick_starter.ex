defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts "Starting kick starter....."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    http_server_pid = start_server()
    {:ok, http_server_pid}
  end

  def handle_info({:EXIT, _child_process_pid, message}, _state) do
    IO.puts "exit signal received: #{inspect message}"
    new_http_server_pid = start_server()
    {:noreply, new_http_server_pid}
  end

  defp start_server do
    IO.puts "Starting http server"
    http_server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.link(http_server_pid)
    Process.register(http_server_pid, :http_server)
    http_server_pid
  end
end
