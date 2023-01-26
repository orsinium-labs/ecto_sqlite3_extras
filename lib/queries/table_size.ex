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
    /* ECTO_SQLITE3_EXTRAS: Size of the tables (excluding indexes), descending by size */

    SELECT schema, name, pgsize AS size
    FROM dbstat
    ORDER BY size DESC;
    """
  end
end
