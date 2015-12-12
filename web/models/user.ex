defmodule Wedding.User do
  use Wedding.Web, :model

  alias Wedding.Repo

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :crypted_password, :string

    has_many :tasks, Wedding.Task
    has_many :guests, Wedding.Guest

    timestamps
  end

  @required_fields ~w(username password)
  @optional_fields ~w(crypted_password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 5)
  end

  def login_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(username password), ~w())
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 5)
  end
  
  def stored_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(id username crypted_password), ~w())
  end

  def with_guests do
    from u in Wedding.User,
    preload: [:guests]
  end

  def with_guests(user_id) do
    from u in with_guests,
    where: u.id == ^user_id
  end

  def guest_stats do
    from u in Wedding.User,
    inner_join: g in assoc(u, :guests),
    group_by: [g.coming, u.id],
    order_by: [g.coming, u.id],
    select: {u.id, u.username, count(g.id), g.coming}
  end

  def guest_stats(user_id) do
    from u in guest_stats,
    where: u.id == ^user_id
  end

  defp make_guest_stats([{uid, username, not_coming, false},
                         {uid, username, coming, true}]) do
    [id: uid, username: username, coming: coming, total: not_coming + coming]
  end

  defp make_guest_stats([{uid, username, not_coming, false}]) do
    [id: uid, username: username, coming: 0, total: not_coming]
  end

  defp make_guest_stats([{uid, username, coming, true}]) do
    [id: uid, username: username, coming: coming, total: coming]
  end

  def get_guest_stats do
    stats = Repo.all guest_stats
    stats |> Enum.map(&make_guest_stats/1)
  end

  def get_guest_stats(user_id) do
    stats = Repo.all guest_stats(user_id)
    make_guest_stats(stats)
  end

  def task_stats do
    from u in Wedding.User,
    inner_join: t in assoc(u, :tasks),
    group_by: [t.status, u.id],
    order_by: [t.status, u.id],
    select: {u.id, u.username, count(t.id), t.status}
  end

  def task_stats(user_id) do
    from u in task_stats,
    where: u.id == ^user_id
  end

  defp make_task_stats([{uid, username, not_done, false},
                        {uid, username, done, true}]) do
    [id: uid, username: username, done: done, total: done + not_done]
  end

  defp make_task_stats([{uid, username, not_done, false}]) do
    [id: uid, username: username, done: 0, total: not_done]
  end

  defp make_task_stats([{uid, username, done, true}]) do
    [id: uid, username: username, done: done, total: done]
  end

  def get_task_stats(user_id) do
    stats = Repo.all task_stats(user_id)
    make_task_stats(stats)
  end
end
