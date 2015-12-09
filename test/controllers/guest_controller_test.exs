defmodule Wedding.GuestControllerTest do
  use Wedding.ConnCase

  alias Wedding.Guest
  @valid_attrs %{coming: true, name: "some content", plusone: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, guest_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing guests"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, guest_path(conn, :new)
    assert html_response(conn, 200) =~ "New guest"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, guest_path(conn, :create), guest: @valid_attrs
    assert redirected_to(conn) == guest_path(conn, :index)
    assert Repo.get_by(Guest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, guest_path(conn, :create), guest: @invalid_attrs
    assert html_response(conn, 200) =~ "New guest"
  end

  test "shows chosen resource", %{conn: conn} do
    guest = Repo.insert! %Guest{}
    conn = get conn, guest_path(conn, :show, guest)
    assert html_response(conn, 200) =~ "Show guest"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, guest_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    guest = Repo.insert! %Guest{}
    conn = get conn, guest_path(conn, :edit, guest)
    assert html_response(conn, 200) =~ "Edit guest"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    guest = Repo.insert! %Guest{}
    conn = put conn, guest_path(conn, :update, guest), guest: @valid_attrs
    assert redirected_to(conn) == guest_path(conn, :show, guest)
    assert Repo.get_by(Guest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    guest = Repo.insert! %Guest{}
    conn = put conn, guest_path(conn, :update, guest), guest: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit guest"
  end

  test "deletes chosen resource", %{conn: conn} do
    guest = Repo.insert! %Guest{}
    conn = delete conn, guest_path(conn, :delete, guest)
    assert redirected_to(conn) == guest_path(conn, :index)
    refute Repo.get(Guest, guest.id)
  end
end
