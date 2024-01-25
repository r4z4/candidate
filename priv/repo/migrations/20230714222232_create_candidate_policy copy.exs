defmodule FanCan.Repo.Migrations.CreateCandidatePolicy do
  use Ecto.Migration

  def change do
    # create table(:candidate_policy, primary_key: false) do
    #   add :id, :binary_id, primary_key: true
    #   add :policy_embedding, :vector, size: 20
    #   timestamps()
    # end

    # create index("candidate_policy", ["policy_embedding vector_l2_ops"], using: :ivfflat)
  end
end
