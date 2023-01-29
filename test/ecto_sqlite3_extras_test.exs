defmodule EctoSQLite3ExtrasTest do
  use ExUnit.Case
  doctest EctoSQLite3Extras
  alias EctoSQLite3Extras.TestRepo

  test "all queries define info" do
    qs = EctoSQLite3Extras.queries()
    assert map_size(qs) == 6

    for pair <- qs do
      {name, module} = pair
      assert is_atom(name)

      info = module.info()
      assert String.length(info.title) > 5
      assert length(info.columns) > 0
      assert info.index > 0

      for column <- info.columns do
        assert column.name
        assert column.type
      end

      for {order_by, dir} <- info[:order_by] do
        assert dir in [:asc, :desc]
        assert Enum.find(info.columns, &(&1.name == order_by))
      end
    end
  end

  describe "database interaction" do
    setup do
      start_supervised!(EctoSQLite3Extras.TestRepo)
      :ok
    end

    test "run queries by param" do
      for query_name <- EctoSQLite3Extras.queries(TestRepo) |> Map.keys() do
        result = EctoSQLite3Extras.query(query_name, TestRepo, format: :raw)
        info = EctoSQLite3Extras.queries()[query_name].info
        assert length(result.columns) == length(info.columns)
        assert result.num_rows > 0
      end
    end
  end
end
