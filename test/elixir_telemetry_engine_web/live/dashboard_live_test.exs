defmodule ElixirTelemetryEngineWeb.DashboardLiveTest do
  use ElixirTelemetryEngineWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirTelemetryEngine.TelemetryFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}
  defp create_dashboard(_) do
    dashboard = dashboard_fixture()

    %{dashboard: dashboard}
  end

  describe "Index" do
    setup [:create_dashboard]

    test "lists all dashboards", %{conn: conn, dashboard: dashboard} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboards")

      assert html =~ "Listing Dashboards"
      assert html =~ dashboard.name
    end

    test "saves new dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Dashboard")
               |> render_click()
               |> follow_redirect(conn, ~p"/dashboards/new")

      assert render(form_live) =~ "New Dashboard"

      assert form_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#dashboard-form", dashboard: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard created successfully"
      assert html =~ "some name"
    end

    test "updates dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#dashboards-#{dashboard.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/dashboards/#{dashboard}/edit")

      assert render(form_live) =~ "Edit Dashboard"

      assert form_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#dashboard-form", dashboard: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dashboards-#{dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_dashboard]

    test "displays dashboard", %{conn: conn, dashboard: dashboard} do
      {:ok, _show_live, html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert html =~ "Show Dashboard"
      assert html =~ dashboard.name
    end

    test "updates dashboard and returns to show", %{conn: conn, dashboard: dashboard} do
      {:ok, show_live, _html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/dashboards/#{dashboard}/edit?return_to=show")

      assert render(form_live) =~ "Edit Dashboard"

      assert form_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#dashboard-form", dashboard: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/dashboards/#{dashboard}")

      html = render(show_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated name"
    end
  end
end
