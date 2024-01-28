defmodule FanCan.Accounts.Jobs.NewsletterEmail do
  use Oban.Worker, queue: :default, max_attempts: 4

  @impl Oban.Worker
  def perform(%{"email" => email}, _job) do
    IO.inspect(email)
    :ok
  end
end
