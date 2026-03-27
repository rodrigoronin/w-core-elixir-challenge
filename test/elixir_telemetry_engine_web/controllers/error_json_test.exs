defmodule ElixirTelemetryEngineWeb.ErrorJSONTest do
  use ElixirTelemetryEngineWeb.ConnCase, async: true

  test "renders 404" do
    assert ElixirTelemetryEngineWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ElixirTelemetryEngineWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
