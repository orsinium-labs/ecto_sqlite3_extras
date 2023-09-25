defmodule EctoSQLite3Extras.MixProject do
  @moduledoc false
  use Mix.Project
  @github_url "https://github.com/orsinium-labs/ecto_sqlite3_extras"
  @version "1.2.0"

  def project do
    [
      app: :ecto_sqlite3_extras,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  defp deps do
    [
      {:exqlite, "~> 0.14.0"},
      {:table_rex, "~> 4.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto_sqlite3, "~> 0.11.0", only: [:test]},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Helpful queries and Phoenix Live Dashboard integration for SQLite.
    """
  end

  defp package do
    [
      maintainers: ["Gram"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @github_url,
      extras: ["README.md"]
    ]
  end
end
