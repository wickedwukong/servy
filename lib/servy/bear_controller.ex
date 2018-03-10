defmodule Servy.BearController do
  alias Servy.Wildthings
  def index(conv) do
    items =
      Wildthings.list_bears
      |> Enum.filter(fn(bear) -> bear.type == "Grizzly" end)
      |> Enum.sort(fn(b1, b2) -> b1.name <= b2.name end)
      |> Enum.map(fn(bear) -> "<li>#{bear.name} - #{bear.type}</li>" end)
      |> Enum.join

    %{conv | resp_body: "<ul>#{items}</ul>", status: 200}
  end

  def show(conv, %{"id" => id}) do
    %{conv | resp_body: "Bear #{id}", status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Created a #{type} bear called #{name}", status: 201}
  end
end
