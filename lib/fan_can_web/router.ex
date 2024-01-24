defmodule FanCanWeb.Router do
  use FanCanWeb, :router

  import FanCanWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FanCanWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # pipeline :messages do
  #   plug :put_root_layout, {FanCanWeb.Layouts, :messages}
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FanCanWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", FanCanWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fan_can, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FanCanWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FanCanWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{FanCanWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/admin/", FanCanWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin_role]
      live "/forums", ForumLive.Index, :index
      live "/forums/new", ForumLive.Index, :new
      live "/forums/:id", ForumLive.Show, :show
      live "/forums/:id/edit", ForumLive.Index, :edit
      live "/forums/:id/show/edit", ForumLive.Show, :edit

      live "/elections", ElectionLive.Index, :index
      live "/elections/new", ElectionLive.Index, :new
      live "/elections/:id/edit", ElectionLive.Index, :edit

      live "/elections/:id", ElectionLive.Show, :show
      live "/elections/:id/show/edit", ElectionLive.Show, :edit

      live "/scenes", Admin.ScenesLive
  end

  scope "/", FanCanWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{FanCanWeb.UserAuth, :ensure_authenticated}] do

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/users/holds", UserHoldsLive, :edit

      live "/home", HomeLive

      live "/elections/main", ElectionLive.Main, :index
      live "/elections/main/:id", ElectionLive.Page
      live "/elections/live/ballot/:id", BallotLive.Template, :template

      # Non-Admin Version
      live "/elections/:id", ElectionLive.Show, :show

      live "/states", StateLive.Index, :index
      live "/states/new", StateLive.Index, :new
      live "/states/:id/edit", StateLive.Index, :edit

      live "/states/:id", StateLive.Show, :show
      live "/states/:id/show/edit", StateLive.Show, :edit

      live "/races", RaceLive.Index, :index
      live "/races/new", RaceLive.Index, :new
      live "/races/:id/edit", RaceLive.Index, :edit

      live "/races/:id", RaceLive.Show, :show
      live "/races/:id/show/edit", RaceLive.Show, :edit

      live "/races/inspect/:id", RaceLive.Inspect, :inspect

      live "/candidates", CandidateLive.Index, :index
      live "/candidates/new", CandidateLive.Index, :new
      live "/candidates/:id/edit", CandidateLive.Index, :edit

      live "/candidates/main", CandidateLive.Main, :main
      live "/candidates/:id", CandidateLive.Show, :show
      live "/candidates/:id/show/edit", CandidateLive.Show, :edit

      ## FIXME
      live "/candidates/:page_number", CandidateLive.Index, :nav

      # Keep a Ballot index for admin etc.. Users will not see it though.
      # Only interact w/ ballots via elections
      live "/ballots", BallotLive.Index, :index
      live "/ballots/new", BallotLive.Index, :new
      live "/ballots/:id/edit", BallotLive.Index, :edit

      live "/ballots/:id", BallotLive.Show, :show
      live "/ballots/:id/show/edit", BallotLive.Show, :edit

      live "/threads", ThreadLive.Index, :index
      live "/threads/new", ThreadLive.Index, :new
      live "/threads/:id/edit", ThreadLive.Index, :edit

      live "/threads/:id", ThreadLive.Show, :show
      live "/threads/:id/show/edit", ThreadLive.Show, :edit
      live "/threads/:id/show/new_post", ThreadLive.Show, :new_post

      live "/posts", PostLive.Index, :index
      live "/posts/new", PostLive.Index, :new
      live "/posts/:id/edit", PostLive.Index, :edit

      live "/posts/:id", PostLive.Show, :show
      live "/posts/:id/show/edit", PostLive.Show, :edit


      # live "/forums", ForumLive.Index, :index
      # live "/forums/new", ForumLive.Index, :new
      # live "/forums/:id/edit", ForumLive.Index, :edit
      # Order matters. Need this before /:id or 'main' gets interpreted as an id
      live "/forums/main", ForumLive.Main, :main
      live "/forums/main/:id", ForumLive.Page, :page
      live "/forums/main/:id/new_thread", ForumLive.Page, :new_thread
      # live "/forums/main/:id/new", ForumLive.ThreadFormComponent, :new
      # Main pages will be list of those items
      live "/forums/main/:id/thread/:id", PostLive.Main, :main
    end
  end

  scope "/", FanCanWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{FanCanWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
