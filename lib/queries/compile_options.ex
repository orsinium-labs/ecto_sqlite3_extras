defmodule EctoSQLite3Extras.CompileOptions do
  @moduledoc """
  Compile-time options used when building SQLite
  """
  @behaviour EctoSQLite3Extras.Query

  def info do
    %{
      title: "Compile-time options used when building SQLite",
      index: 6,
      order_by: [value: :asc],
      columns: [
        %{name: :value, type: :integer}
      ]
    }
  end

  def query(_args \\ []) do
    """
    /* from ecto_sqlite3_extras */
    SELECT compile_options AS 'value' FROM pragma_compile_options;
    """
  end
end
