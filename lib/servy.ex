defmodule Servy do
  use Application

  def hello(name) do
    "Hello #{name}"
  end

  def start(_type, _arg) do
    IO.puts "Starting the #{__MODULE__} application..."
    Servy.Supervisor.start_link()
  end
end

IO.puts Servy.hello("Elixir")
