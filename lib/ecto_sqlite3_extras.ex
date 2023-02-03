defmodule EctoSQLite3Extras do
  @moduledoc """
  Query stats about an SQLite database.
  """

  @typedoc """
  Ecto repository module (or a pair of the module and the remote node).
  """
  @type repo :: module() | {module(), node()}

  @doc """
  Get the map of all available queries.

  Key: The friendly query name atom (the same as the function name).

  Value: The name of the module defining the query behavior.
  """
  @spec queries(repo() | nil) :: %{atom() => module()}
  def queries(_repo \\ nil) do
    # ordered by "index" value
    %{
      total_size: EctoSQLite3Extras.TotalSize,
      table_size: EctoSQLite3Extras.TableSize,
      index_size: EctoSQLite3Extras.IndexSize,
      sequence_number: EctoSQLite3Extras.SequenceNumber,
      pragma: EctoSQLite3Extras.Pragma,
      integrity_check: EctoSQLite3Extras.IntegrityCheck
    }
  end

  @doc """
  Total size of all tables and indices.
  """
  @spec total_size(repo(), keyword()) :: any()
  def total_size(repo, opts \\ []), do: query(:total_size, repo, opts)

  @doc """
  Size of tables (without indices).
  """
  @spec table_size(repo(), keyword()) :: any()
  def table_size(repo, opts \\ []), do: query(:table_size, repo, opts)

  @doc """
  Size of indices.
  """
  @spec index_size(repo(), keyword()) :: any()
  def index_size(repo, opts \\ []), do: query(:index_size, repo, opts)

  @doc """
  Sequence numbers of autoincrement columns.

  The query will fail if there are no autoincrement columns in the DB yet.
  """
  @spec sequence_number(repo(), keyword()) :: any()
  def sequence_number(repo, opts \\ []), do: query(:sequence_number, repo, opts)

  @doc """
  Values of all bool or integer PRAGMAs.
  """
  @spec pragma(repo(), keyword()) :: any()
  def pragma(repo, opts \\ []), do: query(:pragma, repo, opts)

  @doc """
  Run integrity checks on the database.
  """
  @spec integrity_check(repo(), keyword()) :: any()
  def integrity_check(repo, opts \\ []), do: query(:integrity_check, repo, opts)

  @doc """
  Run the query specified by its slug atom and get (or print) the result.
  """
  @spec query(module(), repo(), keyword()) :: any()
  def query(module_name, repo, opts \\ []) do
    query_module = Map.fetch!(queries(repo), module_name)
    sql_query = query_module.query(Keyword.get(opts, :args, []))
    query_opts = Keyword.get(opts, :query_opts, log: false)
    format_name = Keyword.get(opts, :format, :ascii)

    repo
    |> query!(sql_query, query_opts)
    |> preformat()
    |> format(format_name, query_module.info)
  end

  # run query on a remote node
  defp query!({repo, node}, query, query_opts) do
    case :rpc.call(node, repo, :query!, [query, [], query_opts]) do
      {:badrpc, {:EXIT, {:undef, _}}} ->
        raise "repository is not defined on remote node"

      {:badrpc, error} ->
        raise "cannot send query to remote node #{inspect(node)}. Reason: #{inspect(error)}"

      result ->
        result
    end
  end

  # run query on the current node
  defp query!(repo, query, query_opts) do
    repo.query!(query, [], query_opts)
  end

  # format summary tables based on the name in the first row
  defp preformat(%{columns: [_, _], rows: rows} = result) do
    rows = rows |> Enum.map(&format_row/1)
    Map.replace!(result, :rows, rows)
  end

  defp preformat(result) do
    result
  end

  defp format(result, :raw, _info), do: result
  defp format(%{rows: []}, :ascii, _info), do: "No results"

  defp format(result, :ascii, info) do
    names = Enum.map(info.columns, & &1.name)
    types = Enum.map(info.columns, & &1.type)

    result.rows
    |> Enum.map(&format_row(&1, types))
    |> TableRex.quick_render!(names, info.title)
    |> IO.puts()
  end

  defp format_row(values, types) do
    Enum.zip(values, types) |> Enum.map(&format_value/1)
  end

  defp format_row([name, value]) do
    if String.ends_with?(name, "_size") do
      [name, format_bytes(value)]
    else
      [name, value]
    end
  end

  defp format_value({integer, :bytes}) when is_integer(integer), do: format_bytes(integer)
  defp format_value({binary, _}) when is_binary(binary), do: binary
  defp format_value({other, _}), do: inspect(other)

  defp format_bytes(bytes) do
    cond do
      bytes >= memory_unit(:TB) -> format_bytes(bytes, :TB)
      bytes >= memory_unit(:GB) -> format_bytes(bytes, :GB)
      bytes >= memory_unit(:MB) -> format_bytes(bytes, :MB)
      bytes >= memory_unit(:KB) -> format_bytes(bytes, :KB)
      true -> "#{bytes} B"
    end
  end

  defp format_bytes(bytes, unit) do
    value = bytes / memory_unit(unit)
    "#{:erlang.float_to_binary(value, decimals: 1)} #{unit}"
  end

  defp memory_unit(:TB), do: 1024 * 1024 * 1024 * 1024
  defp memory_unit(:GB), do: 1024 * 1024 * 1024
  defp memory_unit(:MB), do: 1024 * 1024
  defp memory_unit(:KB), do: 1024
end
