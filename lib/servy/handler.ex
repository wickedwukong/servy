defmodule Servy.Handler do
  @pages_path Path.expand("../../pages", __DIR__)
  import Servy.Plugins, only: [rewrite_path: 1, log: 1]
  import Servy.Parser, only: [parse: 1]
  alias Servy.Conv, as: Conv
  alias Servy.BearController

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    # Map.put(conv, :resp_body, "Bears, Lions, Tigers")
    %{conv | resp_body: "Bears, Lions, Tigers", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.request_params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.request_params)
  end


  def route(%Conv{method: _, path: path} = conv) do
    %{conv | resp_body: "No resource found at #{path}", status: 404}
  end

  def handle_file({:ok, :eoent}, conv) do
      %{conv | resp_body: "File not found", status: 404}
  end

  def handle_file({:ok, content}, conv) do
      %{conv | resp_body: content, status: 200}
  end

  def handle_file({:error, reason}, conv) do
      %{conv | resp_body: "File error: #{reason}", status: 500}
  end

# def route(%{method: _, path: "/about"} = conv) do
#     file =
#       "../../pages"
#         |> Path.expand(__DIR__)
#         |> Path.join("about.html")
#
#     case File.read(file) do
#       {:ok, content} ->
#           %{conv | resp_body: content, status: 200}
#
#       {:error, :eoent} ->
#           %{conv | resp_body: "File not found", status: 404}
#       {:error, reason} ->
#           %{conv | resp_body: "File error: #{reason}", status: 500}
#     end
#   end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
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

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response
