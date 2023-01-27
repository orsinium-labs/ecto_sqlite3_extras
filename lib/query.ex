defmodule EctoSQLite3Extras.Query do
  @moduledoc """
  The entry point for each function.
  """

  @callback info :: %{
              required(:title) => binary,
              required(:columns) => [%{name: atom, type: atom}],
              required(:order_by) => [{atom, :asc | :desc}],
              required(:index) => integer,
              optional(:default_args) => list,
              optional(:args_for_select) => list
            }

  @callback query :: binary
end
