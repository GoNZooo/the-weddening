defmodule Wedding.Guest do
  use Wedding.Web, :model

  schema "guests" do
    field :name, :string
    field :coming, :boolean, default: false
    field :plusone, :string
    belongs_to :user, Wedding.User

    timestamps
  end

  @required_fields ~w(name coming plusone)
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
