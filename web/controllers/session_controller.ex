defmodule Wedding.SessionController do
  use Wedding.Web, :controller

  alias Wedding.User
  alias Wedding.Repo
  alias Comeonin.Bcrypt

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{})
    username = user_params["username"]
    password = user_params["password"]

    case Repo.get_by(User, username: username) do
      nil ->
        render conn, "new.html", changeset: changeset
      user ->
        if Bcrypt.checkpw(password, user.crypted_password) do
          conn
          |> put_session(:logged_in, username)
          |> redirect(to: task_path(conn, :index))
        else
          render conn, "new.html", changeset: changeset
        end
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:logged_in)
    |> redirect(to: page_path(conn, :index))
  end
end
