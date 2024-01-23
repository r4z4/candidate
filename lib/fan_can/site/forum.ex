defmodule FanCan.Site.Forum do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias FanCan.Core.Utils
  alias FanCan.Repo
  alias FanCan.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "forums" do
    field :category, Ecto.Enum, values: Utils.forum_categories
    field :members, {:array, :binary_id}
    field :desc, :string
    field :title, :string
    field :moderator, :binary_id

    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, [:title, :category, :members, :shares, :moderator, :desc])
    |> validate_required([:title, :category])
  end

  alias FanCan.Site.Forum.{Thread, ThreadPlus}
  
  @doc """
  Returns the threads for a particular forum based on forum_id.

  ## Examples

      iex> get_forum_threads(id)
      [%Post{}, ...]

  """
  def get_forum_threads(id) do
    query = from t in Thread,
      join: u in User,
      on: t.creator == u.id,
      where: t.forum_id == ^id,
      # FIXME Change this to confirmed_at > inserted_at
      # Or can do "id" => r.id, "candidates" => .... then access via ballot_race["id"] in template.
      select: %{:id => t.id, :title => t.title, :forum_id => t.forum_id, :content => t.content, :creator => t.creator, :creator_name => u.username, :likes => t.likes, :shares => t.shares, :inserted_at => t.inserted_at, :updated_at => t.updated_at}
      # select: {u.username, u.email, u.inserted_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished, 
      #           us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}
      # distinct: p.id
      # where: u.age > type(^age, :integer)
    FanCan.Repo.all(query)
  end

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads do
    Repo.all(Thread)
  end

  def list_threads_plus do
    query = from t in Thread,
      join: u in User,
      on: t.creator == u.id,
      # FIXME Change this to confirmed_at > inserted_at
      # Or can do "id" => r.id, "candidates" => .... then access via ballot_race["id"] in template.
      select: %ThreadPlus{:id => t.id, :title => t.title, :forum_id => t.forum_id, :content => t.content, :creator => t.creator, :creator_name => u.username, :likes => t.likes, :shares => t.shares, :inserted_at => t.inserted_at, :updated_at => t.updated_at}
      # select: {u.username, u.email, u.inserted_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished, 
      #           us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}
      # distinct: p.id
      # where: u.age > type(^age, :integer)
    FanCan.Repo.all(query)
  end


  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id), do: Repo.get!(Thread, id)

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end

  alias FanCan.Site.Forum.Post

  @doc """
  Returns the posts for a particular thread based on thread_id.

  ## Examples

      iex> get_thread_posts(id)
      [%Post{}, ...]

  """
  def get_thread_posts(id) do
    query = from p in Post,
      join: u in User,
      on: p.author == u.id,
      where: p.thread_id == ^id,
      # FIXME Change this to confirmed_at > inserted_at
      # Or can do "id" => r.id, "candidates" => .... then access via ballot_race["id"] in template.
      select: %{:id => p.id, :title => p.title, :content => p.content, :author => u.username, :upvotes => p.upvotes, :downvotes => p.downvotes, :inserted_at => p.inserted_at, :updated_at => p.updated_at}
      # select: {u.username, u.email, u.inserted_at, us.easy_games_played, us.easy_games_finished, us.med_games_played, us.med_games_finished, us.hard_games_played, us.hard_games_finished, 
      #           us.easy_poss_pts, us.easy_earned_pts, us.med_poss_pts, us.med_earned_pts, us.hard_poss_pts, us.hard_earned_pts}
      # distinct: p.id
      # where: u.age > type(^age, :integer)
    FanCan.Repo.all(query)
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
