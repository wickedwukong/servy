defmodule Servy.BearController do
  def index(conv) do
    %{conv | resp_body: "Paddington, Smokey, Teddy", status: 200}
  end

  def show(conv, %{"id" => id}) do
    %{conv | resp_body: "Bear #{id}", status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Created a #{type} bear called #{name}", status: 201}
  end
end
