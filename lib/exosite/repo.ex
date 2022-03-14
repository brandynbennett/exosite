defmodule Exosite.Repo do
  use Ecto.Repo,
    otp_app: :exosite,
    adapter: Ecto.Adapters.Postgres
end
