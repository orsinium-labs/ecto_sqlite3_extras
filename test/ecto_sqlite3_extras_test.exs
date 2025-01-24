defmodule EctoSQLite3ExtrasTest do
  @moduledoc false
  use ExUnit.Case
  doctest EctoSQLite3Extras
  alias EctoSQLite3Extras.EmptyTestRepo
  alias EctoSQLite3Extras.TestRepo
  import ExUnit.CaptureIO

  test "all queries define info" do
    qs = EctoSQLite3Extras.queries()
    assert map_size(qs) == 7

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
      start_supervised!(EctoSQLite3Extras.EmptyTestRepo)
      :ok
    end

    test "run queries by param" do
      for query_name <- EctoSQLite3Extras.queries(TestRepo) |> Map.keys() do
        result = EctoSQLite3Extras.query(query_name, TestRepo, format: :raw)
        info = EctoSQLite3Extras.queries()[query_name].info()
        assert length(result.columns) == length(info.columns)
        names = Enum.map(info.columns, &Atom.to_string(&1.name))
        assert result.columns == names
        assert result.num_rows > 0
      end
    end

    test "run queries on empty database" do
      for query_name <- EctoSQLite3Extras.queries(EmptyTestRepo) |> Map.keys() do
        result = EctoSQLite3Extras.query(query_name, EmptyTestRepo, format: :raw)
        info = EctoSQLite3Extras.queries()[query_name].info()
        assert length(result.columns) == length(info.columns)
        names = Enum.map(info.columns, &Atom.to_string(&1.name))
        assert result.columns == names
      end
    end

    test "run total_size query using the function" do
      expected = [
        ["pages", 864],
        ["cells", 49_351],
        ["payload_size", "597.2 KB"],
        ["unused_size", "82.0 KB"],
        ["vacuum_size", "184.8 KB"],
        ["page_size", "864.0 KB"],
        ["pages: leaf", 840],
        ["pages: internal", 24],
        ["pages: overflow", 0],
        ["pages: table", 466],
        ["pages: index", 389]
      ]

      result = EctoSQLite3Extras.total_size(TestRepo, format: :raw)
      assert result.rows == expected
    end

    test "ascii format" do
      for query_name <- EctoSQLite3Extras.queries(TestRepo) |> Map.keys() do
        result =
          capture_io(fn ->
            EctoSQLite3Extras.query(query_name, TestRepo, format: :ascii)
          end)

        assert String.contains?(result, " |")
        assert String.contains?(result, "| ")
        assert String.contains?(result, "+-")
      end
    end
  end
end
