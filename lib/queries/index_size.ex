defmodule EctoSQLite3Extras.IndexSize do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Size of indices, descending by size",
      index: 1,
      order_by: [size: :desc],
      columns: [
        %{name: :name, type: :string},
        %{name: :size, type: :integer}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT name, SUM(payload) AS size
    FROM dbstat
    WHERE name IN (SELECT name FROM sqlite_schema WHERE type='index')
    GROUP BY name
    ORDER BY size DESC;
    """
  end
end
