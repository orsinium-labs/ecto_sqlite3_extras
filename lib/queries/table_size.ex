defmodule EctoSQLite3Extras.TableSize do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Size of tables (without indices)",
      index: 2,
      order_by: [page_size: :desc],
      columns: [
        %{name: :name, type: :string},
        %{name: :payload_size, type: :bytes},
        %{name: :unused_size, type: :bytes},
        %{name: :page_size, type: :bytes},
        %{name: :cells, type: :integer},
        %{name: :pages, type: :integer},
        %{name: :max_payload_size, type: :bytes}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT
        name,
        payload AS payload_size,
        unused as unused_size,
        pgsize as page_size,
        ncell as cells,
        pageno as pages,
        mx_payload as max_payload_size
    FROM dbstat
    WHERE
        name IN (SELECT name FROM sqlite_schema WHERE type='table')
        AND aggregate=TRUE
    ORDER BY page_size DESC;
    """
  end
end
