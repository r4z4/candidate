defmodule FanCan.Site.Forum.ThreadPlus do
  defstruct id: Ecto.UUID.generate(), title: "Default Title", forum_id: "8d04fd4f-1321-4e9f-911a-7369d57d0b55", content: "Default Content", creator: "b5f44567-e031-44f1-aae6-972d7aabbb45", creator_name: "jim_the_og", likes: 0, shares: 0, inserted_at: NaiveDateTime.local_now(), updated_at: NaiveDateTime.local_now()
end
