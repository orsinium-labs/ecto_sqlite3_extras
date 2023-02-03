defmodule EctoSQLite3Extras.SequenceNumber do
  @moduledoc """
  Sequence numbers of autoincrement columns
  """
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

  # TODO(@orsinium): The query fails if the table doesn't exist.
  # The table is created only when the first autoincrement column is created.
  # Can we fix it without doing INSERTs?
  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT name AS table_name, seq AS sequence_number
    FROM sqlite_sequence
    ORDER BY sequence_number DESC
    """
  end
end
