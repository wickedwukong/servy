defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
  def parse(raw_request) do
    [top, request_params] = String.split(raw_request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")
    [method, path | _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], request_params)

    %Conv{
      method: method,
      path: path,
      request_params: params,
      headers: headers
    }
  end

  defp parse_params("application/x-www-form-urlencoded", request_params) do
      request_params |> String.trim |> URI.decode_query
  end

  defp parse_params(_, _), do: %{}

  defp parse_headers(header_lines, headers \\ %{})
  defp parse_headers([], headers), do: headers
  defp parse_headers([head | tail], headers) do
    parse_headers(tail, Map.put(headers, Enum.at(String.split(head, ": "),0), Enum.at(String.split(head, ": "),1)))
  end

end
