defmodule ElixirTelemetryEngineWeb.PageController do
  use ElixirTelemetryEngineWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
