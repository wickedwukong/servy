defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> format_response
  end

  def rewrite_path(%{method: "GET", path: "/wildlife"} = request_map) do
    %{request_map | path: "/wildthings"}
  end

  def rewrite_path(request_map), do: request_map

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

  def route(%{method: "GET", path: "/wildthings"} = request_map) do
    # Map.put(request_map, :resp_body, "Bears, Lions, Tigers")
    %{request_map | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = request_map) do
    %{request_map | resp_body: "Paddington, Smokey, Teddy", status: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = request_map) do
    %{request_map | resp_body: "Bear #{id}", status: 200}
  end

  def route(%{method: _, path: "/about"} = request_map) do
    case File.read("pages/about.html") do
      {:ok, content} ->
          %{request_map | resp_body: content, status: 200}

      {:error, :eoent} ->
          %{request_map | resp_body: "File not found", status: 404}
      {:error, reason} ->
          %{request_map | resp_body: "File error: #{reason}", status: 500}
    end
  end

  def route(%{method: _, path: path} = request_map) do
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

  def log(conv), do: IO.inspect conv

end



request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
