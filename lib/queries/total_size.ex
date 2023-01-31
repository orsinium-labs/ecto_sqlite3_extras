defmodule EctoSQLite3Extras.TotalSize do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Total size of all tables and indices",
      index: 1,
      order_by: [name: :asc],
      columns: [
        %{name: :name, type: :string},
        %{name: :value, type: :integer}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT 'pages' AS name,      MAX(pageno) as value FROM dbstat
    UNION ALL SELECT 'cells',    SUM(ncell)    FROM dbstat
    UNION ALL SELECT 'payload_size',  SUM(payload)  FROM dbstat
    UNION ALL SELECT 'unused_size',   SUM(unused)   FROM dbstat
    UNION ALL SELECT 'vacuum_size',   SUM(pgsize) - SUM(payload) - SUM(unused) FROM dbstat
    UNION ALL SELECT 'page_size',     SUM(pgsize)   FROM dbstat
    UNION ALL SELECT 'pages',         COUNT(*)      FROM dbstat

    UNION ALL SELECT 'pages: leaf', COUNT(*)
        FROM dbstat WHERE pagetype = 'leaf'
    UNION ALL SELECT 'pages: internal', COUNT(*)
        FROM dbstat WHERE pagetype = 'internal'
    UNION ALL SELECT 'pages: overflow', COUNT(*)
        FROM dbstat WHERE pagetype = 'overflow'
    UNION ALL SELECT 'pages: table', COUNT(*)
        FROM dbstat WHERE name IN (SELECT name FROM sqlite_schema WHERE type='table')
    UNION ALL SELECT 'pages: index', COUNT(*)
        FROM dbstat WHERE name IN (SELECT name FROM sqlite_schema WHERE type='index')
    """
  end
end
