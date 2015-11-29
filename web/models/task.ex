defmodule Wedding.Task do
  use Wedding.Web, :model

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :boolean, default: false
    belongs_to :user, Wedding.User

    timestamps
  end

  @required_fields ~w(user_id title description status)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
