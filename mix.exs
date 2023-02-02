defmodule EctoSQLite3Extras.MixProject do
  use Mix.Project
  @github_url "https://github.com/orsinium-labs/ecto_sqlite3_extras"
  @version "1.1.5"

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
      {:exqlite, "~> 0.13.2"},
      {:table_rex, "~> 3.1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto_sqlite3, "~> 0.9.1", only: [:test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
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
