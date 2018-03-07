defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
  def parse(raw_request) do
    [method, path|_] =
      raw_request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path,
    }
  end
end
