defmodule EctoSQLite3Extras do
  @moduledoc """
  Query stats about an SQLite database.
  """
  @type repo :: module() | {module(), node()}

  @spec queries(repo() | nil) :: map()
  def queries(_repo \\ nil) do
    # ordered by "index" value
    %{
      total_size: EctoSQLite3Extras.TotalSize,
      table_size: EctoSQLite3Extras.TableSize,
      index_size: EctoSQLite3Extras.IndexSize,
      sequence_number: EctoSQLite3Extras.SequenceNumber,
      settings: EctoSQLite3Extras.Settings
    }
  end

  @default_query_opts [log: false]

  def total_size(repo, opts \\ []), do: query(:total_size, repo, opts)
  def index_size(repo, opts \\ []), do: query(:index_size, repo, opts)
  def table_size(repo, opts \\ []), do: query(:table_size, repo, opts)
  def sequence_number(repo, opts \\ []), do: query(:sequence_number, repo, opts)
  def settings(repo, opts \\ []), do: query(:settings, repo, opts)

  def query(name, repo, opts \\ @default_query_opts)

  def query(name, repo, opts) do
    query_module = Map.fetch!(queries(repo), name)

    opts =
      Keyword.merge(
        [
          format: Keyword.get(opts, :format, :ascii),
          args: Keyword.merge(query_module.info[:default_args] || [], opts[:args] || [])
        ],
        opts
      )

    result =
      query!(
        repo,
        query_module.query(Keyword.fetch!(opts, :args)),
        Keyword.get(opts, :query_opts, @default_query_opts)
      )

    format(
      Keyword.fetch!(opts, :format),
      query_module.info,
      result
    )
  end

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

  defp query!(repo, query, query_opts) do
    repo.query!(query, [], query_opts)
  end

  defp format(:raw, _info, result) do
    result
  end
end
