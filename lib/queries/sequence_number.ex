defmodule EctoSQLite3Extras.SequenceNumber do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Sequence numbers of autoincrement columns",
      index: 4,
      order_by: [sequence_number: :desc],
      columns: [
        %{name: :table_name, type: :string},
        %{name: :sequence_number, type: :integer}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT name AS table_name, seq AS sequence_number
    FROM sqlite_sequence
    ORDER BY sequence_number DESC
    """
  end
end
