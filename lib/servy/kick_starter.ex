defmodule Servy.KickStarter do
  use GenServer

  @name :http_server

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    http_server_pid = spawn(Servy.HttpServer, :start, [4000])
    Process.register(http_server_pid, @name)

    {:ok, http_server_pid}
  end
end
