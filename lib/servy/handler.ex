defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(raw_request) do
    [method, path|_] =
      raw_request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(request_map) do
    # Map.put(request_map, :resp_body, "Bears, Lions, Tigers")
    %{request_map | resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(resposne_map) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(resposne_map.resp_body)}

    """
  end
end
