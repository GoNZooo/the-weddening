defmodule Wedding.GuestController do
  use Wedding.Web, :controller

  alias Wedding.Guest
  alias Wedding.User

  plug :scrub_params, "guest" when action in [:create, :update]

  def index(conn, _params) do
    guests = Repo.all Guest
    guest_stats = users
    |> Enum.map(fn u -> User.get_guest_stats(u.id) end)
    num_guests_coming = guest_stats
    |> Enum.map(fn u -> u[:coming] end)
    |> Enum.sum
    guest_count = guest_stats
    |> Enum.map(fn u -> u[:total] end)
    |> Enum.sum

    render(conn, "index.html",
           guest_stats: guest_stats, num_guests_coming: num_guests_coming,
           guest_count: guest_count, guests: guests)
  end

  def new(conn, _params) do
    changeset = Guest.changeset(%Guest{})
    users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"guest" => guest_params}) do
    changeset = Guest.changeset(%Guest{}, guest_params)

    case Repo.insert(changeset) do
      {:ok, _guest} ->
        conn
        |> put_flash(:info, "Guest created successfully.")
        |> redirect(to: guest_path(conn, :index))
      {:error, changeset} ->
        users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    users = Enum.into Repo.all(User), %{}, fn u -> {u.id, u.username} end
    render(conn, "show.html", guest: guest, users: users)
  end

  def edit(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest)
    users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
    render(conn, "edit.html", guest: guest, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "guest" => guest_params}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest, guest_params)

    case Repo.update(changeset) do
      {:ok, guest} ->
        conn
        |> put_flash(:info, "Guest updated successfully.")
        |> redirect(to: guest_path(conn, :show, guest))
      {:error, changeset} ->
        render(conn, "edit.html", guest: guest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(guest)

    conn
    |> put_flash(:info, "Guest deleted successfully.")
    |> redirect(to: guest_path(conn, :index))
  end
end
