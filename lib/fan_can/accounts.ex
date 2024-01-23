defmodule FanCan.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias FanCan.Repo

  alias FanCan.Accounts.{User, UserToken, UserNotifier, UserHolds}
  alias FanCan.Site.Forum.{Post, Thread}
  alias FanCan.Public.Election
  alias FanCan.Core.Holds

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end


  def get_all_user_info(token) do
    query = from u in User,
      join: h in Holds,
      on: h.user_id == u.id,
      join: ut in UserToken,
      on: ut.user_id == u.id,
      where: ut.token == ^token,
      where: h.hold_cat == :user,
      # FIXME Change this to confirmed_at > inserted_at
      select: {u.username, u.email, u.inserted_at, {h.type, h.follow_ids}}
      # select: {u.username, u.email, u.inserted_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished, 
      #           us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}
      # distinct: p.id
      # where: u.age > type(^age, :integer)

    FanCan.Repo.one(query)
  end

  def get_user_by_token(token)
      when is_binary(token) do
    query = from u in User,
        join: ut in UserToken, on: u.id == ut.user_id
    query = from [u, ut] in query,
          where: ut.token == ^token,
          select: {u}
          # Repo.all returns a list
    # {u} = Repo.one(query)
    Repo.one(query)
  end

  def get_holds_by_token(token, cat)
      when is_binary(token) do
    query = from u in User,
        join: ut in UserToken, on: u.id == ut.user_id,
        join: h in Holds, on: u.id == h.user_id
    query = from [u, ut, h] in query,
          where: ut.token == ^token,
          where: h.hold_cat == ^cat,
          select: h
          # Repo.all returns a list
    Repo.all(query)
  end

  def get_all_holds_by_token(token) do
    user        = get_holds_by_token(token, :user)
    race        = get_holds_by_token(token, :race)
    election    = get_holds_by_token(token, :election)
    candidate   = get_holds_by_token(token, :candidate)
    post        = get_holds_by_token(token, :post)
    thread      = get_holds_by_token(token, :thread)
    
    %{:user_holds => user, :race_holds => race, :election_holds => election, :candidate_holds => candidate, :post_holds => post, :thread_holds => thread}
  end

  def get_user_thread_ids_by_token(token)
      when is_binary(token) do
    query = from u in User,
        join: ut in UserToken, on: u.id == ut.user_id,
        join: t in Thread, on: t.creator == u.id
    query = from [u, ut, t] in query,
          where: ut.token == ^token,
          select: t.id
          # Repo.all returns a list
   Repo.all(query)
  end

  def get_user_post_ids_by_token(token)
      when is_binary(token) do
    query = from u in User,
        join: ut in UserToken, on: u.id == ut.user_id,
        join: p in Post, on: p.author == u.id
    query = from [u, ut, p] in query,
          where: ut.token == ^token,
          select: p.id
          # Repo.all returns a list
    Repo.all(query)
  end

  def update_hold(%Holds{} = hold, attrs) do
    hold
    |> Holds.changeset(attrs)
    |> Repo.update()
  end
  

  @doc """
  Gets a user by user token

  ## Examples

      iex> get_user_data_by_token("currect_token)
      %User{}

      iex> get_user_data_by_token("invalid_token or nil")
      nil

  """
  # def get_user_data_by_token(token)
  #     when is_binary(token) do
  #   query = from u in User,
  #       join: ut in UserToken, on: u.id == ut.user_id
  #   query = from [u, ut] in query,
  #         where: ut.token == ^token,
  #         select: {u.email, u.username}
  #         # Repo.all returns a list
  #   {user_email, username} = Repo.one(query)
  # end

  # def get_user_data_by_id(id) do
  #   query = from u in User,
  #         where: u.id == ^id,
  #         select: {u.email, u.id, u.username, u.user_holds, u.user_post_likes}
  #         # Repo.all returns a list
  #   {user_email, id, username, user_holds, user_post_likes} = Repo.one(query)
  # end



  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets all users in a list of user_ids.

  Raises `Ecto.NoResultsError` if the no users found.

  ## Examples

      iex> get_users(["UUID", "UUID" ... "UUID"])
      [%User{}, %User{} ... %User{}]

      iex> get_users(["UUID", "UUID" ... "UUID"])
      ** (Ecto.NoResultsError)

  """
  def get_users(ids) do
    query =
      from u in User,
      where: u.id in ^ids,
      # & type = :vote
      select: u
    users = FanCan.Repo.all(query)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/users/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &url(~p"/users/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &url(~p"/users/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &url(~p"/users/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
