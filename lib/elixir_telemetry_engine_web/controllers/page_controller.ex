defmodule ElixirTelemetryEngineWeb.PageController do
  use ElixirTelemetryEngineWeb, :controller

  def home(conn, _params) do
    if conn.assigns[:current_scope] do
      redirect(conn, to: "/dashboard")
    else
      redirect(conn, to: "/users/log-in")
    end
  end
end
