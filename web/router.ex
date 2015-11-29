defmodule Wedding.Router do
  use Wedding.Web, :router

  import Wedding.AuthPlug, only: [ensure_logged_in: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authed_area do
    plug :ensure_logged_in
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wedding do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :logout

    scope "/users" do
      pipe_through :authed_area
      resources "/", UserController
    end

    scope "/tasks" do
      pipe_through :authed_area
      resources "/", TaskController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wedding do
  #   pipe_through :api
  # end
end
