defmodule Servy.Conv do
  defstruct [method: "",
               path: "",
               resp_body: "",
               request_params: %{},
               resp_content_type: "text/html",
               headers: %{},
               status: nil]

  def full_status(%Servy.Conv{} = conv) do
    "#{conv.status} #{status_descrition(conv.status)}"
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
