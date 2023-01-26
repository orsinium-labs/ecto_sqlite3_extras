defmodule EctoPSQLExtras.TestRepo do
  use Ecto.Repo, otp_app: :ecto_sqlite3_extras, adapter: Ecto.Adapters.SQLite3

  def init(type, opts) do
    opts = [database: "test_database.db"] ++ opts
    opts[:parent] && send(opts[:parent], {__MODULE__, type, opts})
    {:ok, opts}
  end
end
