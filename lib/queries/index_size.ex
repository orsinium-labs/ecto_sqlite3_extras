defmodule EctoSQLite3Extras.IndexSize do
  @moduledoc """
  Size of indices
  """
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Size of indices",
      index: 3,
      order_by: [page_size: :desc],
      columns: [
        %{name: :name, type: :string},
        %{name: :table_name, type: :string},
        %{name: :column_name, type: :string},
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
        d.name        AS name,
        s.tbl_name    AS table_name,
        i.name        AS column_name,
        d.payload     AS payload_size,
        d.unused      AS unused_size,
        d.pgsize      AS page_size,
        d.ncell       AS cells,
        d.pageno      AS pages,
        d.mx_payload  AS max_payload_size
    FROM
        dbstat AS d,
        sqlite_schema AS s,
        pragma_index_info(d.name) AS i
    WHERE
            d.name      = s.name
        AND s.type      = 'index'
        AND d.aggregate = TRUE
    ORDER BY page_size DESC;
    """
  end
end
