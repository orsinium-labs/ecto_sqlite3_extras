defmodule EctoSQLite3Extras.TestRepo do
  use Ecto.Repo, otp_app: :ecto_sqlite3_extras, adapter: Ecto.Adapters.SQLite3

  def init(type, opts) do
    # https://www.sqlitetutorial.net/wp-content/uploads/2018/03/chinook.zip
    opts = [database: "chinook.db"] ++ opts
    opts[:parent] && send(opts[:parent], {__MODULE__, type, opts})
    {:ok, opts}
  end
end
