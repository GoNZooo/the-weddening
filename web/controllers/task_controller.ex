defmodule Wedding.TaskController do
  use Wedding.Web, :controller

  alias Wedding.Task
  alias Wedding.User

  plug :scrub_params, "task" when action in [:create, :update]

  def index(conn, _params) do
    tasks = Repo.all Task
    users = Enum.into Repo.all(User), [], fn u -> {u.id, u.username} end
    render(conn, "index.html", tasks: tasks, users: users)
  end

  def new(conn, _params) do
    changeset = Task.changeset %Task{}
    users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
    render conn, "new.html", changeset: changeset, users: users
  end

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)

    case Repo.insert(changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, changeset} ->
        users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id, "back_path" => back_path}) do
    task = Repo.get!(Task, id)
    users = Enum.into Repo.all(User), %{}, fn u -> {u.id, u.username} end
    render(conn, "show.html", task: task, users: users, back_path: back_path)
  end

  def edit(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task)
    users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task, back_path: task_path(conn, :index)))
      {:error, changeset} ->
        users = Enum.into Repo.all(User), [], fn u -> {u.username, u.id} end
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
