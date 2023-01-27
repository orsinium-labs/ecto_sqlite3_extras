defmodule EctoSQLite3Extras.TableSize do
  @behaviour EctoSQLite3Extras

  def info do
    %{
      title: "Size of the tables (excluding indexes), descending by size",
      index: 1,
      order_by: [size: :desc],
      columns: [
        %{name: :schema, type: :string},
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
    WHERE name IN (SELECT name FROM sqlite_schema WHERE type='table')
    GROUP BY name
    ORDER BY size DESC;
    """
  end
end
