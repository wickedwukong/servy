defmodule Servy.BearController do
  def index(conv) do
    %{conv | resp_body: "Paddington, Smokey, Teddy", status: 200}
  end
end
