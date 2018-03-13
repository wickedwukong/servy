defmodule Servy.Fetcher do
  def async(fun) do
    parent_pid = self()
    spawn(fn -> send(parent_pid, {:result, fun.(), self()}) end)
  end

  def get_result(pid) do
    receive do {:result, result, ^pid} -> result end
  end
end
