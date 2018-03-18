defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts "Starting kick starter....."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    IO.puts "Starting http server"
    http_server_pid = spawn(Servy.HttpServer, :start, [4000])
    Process.link(http_server_pid)
    Process.register(http_server_pid, :http_server)

    {:ok, http_server_pid}
  end
end
