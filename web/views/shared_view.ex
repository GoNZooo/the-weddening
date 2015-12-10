defmodule Wedding.SharedView do
  use Wedding.Web, :view

  def locations do
    [
      [name: "Countdown",
       path: page_path(Wedding.Endpoint, :index),
       active: false],
      [name: "Tasks",
       path: task_path(Wedding.Endpoint, :index),
       active: false]
    ]
  end

  def locations_logged_in do
    [
      [name: "Countdown",
       path: page_path(Wedding.Endpoint, :index),
       active: false],
      [name: "Tasks",
       path: task_path(Wedding.Endpoint, :index),
       active: false],
      [name: "Guests",
       path: guest_path(Wedding.Endpoint, :index),
       active: false]
    ]
  end

  def navbar(location) do
    Enum.map(locations,
      fn loc ->
        if loc[:name] == location do
          Keyword.put(loc, :active, true)
        else
          loc
        end
      end)
  end

  def navbar_logged_in(location) do
    Enum.map(locations_logged_in,
      fn loc ->
        if loc[:name] == location do
          Keyword.put(loc, :active, true)
        else
          loc
        end
      end)
  end
end
