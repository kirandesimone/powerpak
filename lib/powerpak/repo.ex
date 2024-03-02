defmodule Powerpak.Repo do
  use Ecto.Repo,
    otp_app: :powerpak,
    adapter: Ecto.Adapters.Postgres
end
