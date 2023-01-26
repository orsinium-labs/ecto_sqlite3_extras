defmodule EctoSQLite3ExtrasTest do
  use ExUnit.Case
  doctest EctoSQLite3Extras
  alias EctoPSQLExtras.TestRepo

  test "all queries define info" do
    qs = EctoSQLite3Extras.queries()
    assert map_size(qs) == 1

    for pair <- qs do
      {name, module} = pair
      assert is_atom(name)

      info = module.info()
      assert info.title

      for column <- info.columns do
        assert column.name
        assert column.type
      end

      for {order_by, dir} <- info[:order_by] || [] do
        assert dir in [:asc, :desc]
        assert Enum.find(info.columns, &(&1.name == order_by))
      end
    end
  end
end
