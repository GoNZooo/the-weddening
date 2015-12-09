defmodule Wedding.GuestTest do
  use Wedding.ModelCase

  alias Wedding.Guest

  @valid_attrs %{coming: true, name: "some content", plusone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Guest.changeset(%Guest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Guest.changeset(%Guest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
