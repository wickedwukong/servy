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

    %{method: method,
      path: path,
      resp_body: "",
      status: nil}
  end

  def route(request_map) do
    route(request_map, request_map.method, request_map.path)
  end

  def route(request_map, "GET", "/wildthings") do
    # Map.put(request_map, :resp_body, "Bears, Lions, Tigers")
    %{request_map | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(request_map, "GET", "/bears") do
    %{request_map | resp_body: "Paddington, Smokey, Teddy", status: 200}
  end

  def route(request_map, "GET", "/bears/" <> id) do
    %{request_map | resp_body: "Bear #{id}", status: 200}
  end

  def route(request_map, _, path) do
    %{request_map | resp_body: "No resource found at #{path}", status: 404}
  end

  def format_response(resposne_map) do
    """
    HTTP/1.1 #{resposne_map.status} #{status_descrition(resposne_map.status)}
    Content-Type: text/html
    Content-Length: #{String.length(resposne_map.resp_body)}

    #{resposne_map.resp_body}
    """
  end

  defp status_descrition(status) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[status]
  end
end
