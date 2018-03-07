defmodule Servy.Plugins do
  alias Servy.Conv

  def rewrite_path(%Conv{method: "GET", path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv
end
