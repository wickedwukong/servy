defmodule Servy.HandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  test "parse request" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    assert Servy.Handler.parse(request) == %{method: "GET", path: "/wildthings",
                                            resp_body: "" }
  end
end
