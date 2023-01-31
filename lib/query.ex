defmodule EctoSQLite3Extras.Query do
  @moduledoc """
  The entry point for each function.
  """

  # Meta information about the query
  @callback info :: %{
              # human-readable name of the query
              required(:title) => binary,
              # columns the query execution returns and their types
              required(:columns) => [%{name: atom, type: atom}],
              # the order of the data returned
              required(:order_by) => [{atom, :asc | :desc}],
              # the position of the tab in the live dashboard
              required(:index) => integer
            }

  # Get the SQL query
  @callback query :: binary
end
