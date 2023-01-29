defmodule EctoSQLite3Extras.IntegrityCheck do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Run integrity checks on the database",
      index: 6,
      order_by: [message: :desc],
      columns: [
        %{name: :message, type: :string}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT integrity_check as message
    FROM pragma_integrity_check;
    """
  end
end
