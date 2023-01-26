defmodule EctoSQLite3Extras do
  @moduledoc """
  The entry point for each function.
  """

  @callback info :: %{
              required(:title) => binary,
              required(:columns) => [%{name: atom, type: atom}],
              optional(:order_by) => [{atom, :asc | :desc}],
              optional(:index) => integer,
              optional(:default_args) => list,
              optional(:args_for_select) => list
            }

  @callback query :: binary

  @type repo :: module() | {module(), node()}

  @spec queries(repo() | nil) :: map()
  def queries(_repo \\ nil) do
    %{
      table_size: EctoSQLite3Extras.TableSize
    }
  end

  @default_query_opts [log: false]

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

  @doc """
  Run `table_size` query on `repo`, in the given `format`.

  `format` is either `:ascii` or `:raw`
  """
  def table_size(repo, opts \\ []), do: query(:table_size, repo, opts)
end
