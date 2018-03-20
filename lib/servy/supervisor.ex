defmodule Servy.Supervisor do
	use Supervisor

	def start_link do
		IO.puts "Starting Supervisor"
		Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
	end

	def init(_args) do
		children = [
			Servy.ServicesSupervisor,
			Servy.KickStarter
		]
		Supervisor.init(children, strategy: :one_for_one)
	end
	
end