defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
  def parse(raw_request) do
    [top|request_params] = String.split(raw_request, "\n\n")

    [method, path|_] =
      top
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path,
      request_params: params(request_params)
    }
  end

  defp params([""] = request_params), do: %{}
  defp params([] = request_params), do: %{}

  defp params([request_params] = conv) do
    Enum.map(String.split(request_params, "&"), fn key_value -> String.split(key_value, "=") end)
    |> key_value_map
  end

  defp key_value_map(key_values, map \\ %{}) do
    case key_values do
      [] -> map
      [[key, value] | tail] -> key_value_map(tail, Map.put(map, key, value))
    end
  end
end
