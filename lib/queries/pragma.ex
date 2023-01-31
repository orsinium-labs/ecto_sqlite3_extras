defmodule EctoSQLite3Extras.Pragma do
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Values of all bool or integer PRAGMAs",
      index: 5,
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
    SELECT *
    FROM (
        SELECT 'analysis_limit' AS name, analysis_limit AS value FROM pragma_analysis_limit
        UNION ALL SELECT 'application_id', *          FROM pragma_application_id
        UNION ALL SELECT 'auto_vacuum', *             FROM pragma_auto_vacuum
        UNION ALL SELECT 'automatic_index', *         FROM pragma_automatic_index
        UNION ALL SELECT 'busy_timeout', *            FROM pragma_busy_timeout
        UNION ALL SELECT 'cache_size', *              FROM pragma_cache_size
        UNION ALL SELECT 'cache_spill', *             FROM pragma_cache_spill
        UNION ALL SELECT 'cell_size_check', *         FROM pragma_cell_size_check
        UNION ALL SELECT 'checkpoint_fullfsync', *    FROM pragma_checkpoint_fullfsync
        UNION ALL SELECT 'data_version', *            FROM pragma_data_version
        UNION ALL SELECT 'defer_foreign_keys', *      FROM pragma_defer_foreign_keys
        UNION ALL SELECT 'freelist_count', *          FROM pragma_freelist_count
        UNION ALL SELECT 'fullfsync', *               FROM pragma_fullfsync
        UNION ALL SELECT 'hard_heap_limit', *         FROM pragma_hard_heap_limit
        UNION ALL SELECT 'ignore_check_constraints', * FROM pragma_ignore_check_constraints
        UNION ALL SELECT 'journal_size_limit', *      FROM pragma_journal_size_limit
        UNION ALL SELECT 'legacy_alter_table', *      FROM pragma_legacy_alter_table
        UNION ALL SELECT 'max_page_count', *          FROM pragma_max_page_count
        UNION ALL SELECT 'page_size', *               FROM pragma_page_size
        UNION ALL SELECT 'query_only', *              FROM pragma_query_only
        UNION ALL SELECT 'read_uncommitted', *        FROM pragma_read_uncommitted
        UNION ALL SELECT 'recursive_triggers', *      FROM pragma_recursive_triggers
        UNION ALL SELECT 'reverse_unordered_selects', * FROM pragma_reverse_unordered_selects
        UNION ALL SELECT 'soft_heap_limit', *         FROM pragma_soft_heap_limit
        UNION ALL SELECT 'synchronous', *             FROM pragma_synchronous
        UNION ALL SELECT 'temp_store', *              FROM pragma_temp_store
        UNION ALL SELECT 'threads', *                 FROM pragma_threads
        UNION ALL SELECT 'trusted_schema', *          FROM pragma_trusted_schema
        UNION ALL SELECT 'user_version', *            FROM pragma_user_version
    )
    WHERE value != 0
    """
  end
end
