defmodule Wedding.User do
  use Wedding.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :crypted_password, :string

    has_many :tasks, Wedding.Task

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
end
