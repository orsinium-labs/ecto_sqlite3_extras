defmodule EctoSQLite3Extras.Query do
  @moduledoc """
  The entry point for each function.
  """

  @callback info :: %{
              required(:title) => binary,
              required(:columns) => [%{name: atom, type: atom}],
              required(:order_by) => [{atom, :asc | :desc}],
              required(:index) => integer
            }

  @callback query :: binary
end
