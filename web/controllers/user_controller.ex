defmodule Wedding.UserController do
  use Wedding.Web, :controller

  alias Wedding.User
  alias Comeonin.Bcrypt

  plug :scrub_params, "user" when action in [:create, :update]

  def user_by_id(id) do
    query = from u in User,
    preload: [:tasks],
    select: u
    Repo.get!(query, id)
  end

  def index(conn, _params) do
    users = Repo.all(User)
    current_user = get_session(conn, :logged_in)
    render(conn, "index.html", users: users, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    password_hash = Bcrypt.hashpwsalt(user_params["password"])
    user_data = Map.put(user_params, "crypted_password", password_hash)
    stored_changeset = User.stored_changeset(%User{}, user_data)

    if stored_changeset.valid? do
      case Repo.insert(stored_changeset) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: user_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = user_by_id(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    password_hash = Bcrypt.hashpwsalt(user_params["password"])
    user_data = Map.put(user_params, "crypted_password", password_hash)
    changeset = User.stored_changeset(user, user_data)

    if true do
      case Repo.update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
