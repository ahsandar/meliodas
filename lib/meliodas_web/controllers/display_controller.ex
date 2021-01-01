defmodule MeliodasWeb.DisplayController do
  use MeliodasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
