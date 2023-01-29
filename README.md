# Ecto SQLite3 Extras

Helpful queries and [Phoenix Live Dashboard](https://github.com/phoenixframework/phoenix_live_dashboard) integration for [SQLite](https://sqlite.org/index.html). It's like [ecto_psql_extras](https://github.com/pawurb/ecto_psql_extras) but for SQLite instead of PostgreSQL.

## Installation

The package can be installed by adding `ecto_sqlite3_extras` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_sqlite3_extras, "~> 1.0.0"}
  ]
end
```

## Integrating with Phoenix Live Dashboard

...

![Example of live dashboard with ecto_sqlite3_extras](./assets/live-dashboard.png)

## Using from Elixir

...

## Available queries

1. `table_size`. Information about the space used (and unused) by all tables. Based on the [dbstat](https://www.sqlite.org/dbstat.html) virtual table.
    1. `name`: the table name.
    1. `payload_size`:
    1. `unused_size`:
    1. `page_size`:
    1. `cells`:
    1. `pages`:
    1. `max_payload_size`:
1. `index_size`.
1. `sequence_number`.
    1. `table_name`:
    1. `sequence_number`:
1. `settings`. List values of PRAGMAs (settings). Only includes the ones that have an integer or a boolean value. For bravity, the ones with `0` (`false`) value are excluded from the output (based on the observation that this is the default value for most of the PRAGMAs). Check out the SQLite documentation to learn more about what each PRAGMA means: [PRAGMA Statements](https://www.sqlite.org/pragma.html).
    1. `name`: the name of the PRAGMA as listed in the SQLite documentation.
    1. `value`: the value of the PRAGMA. The `true` value is converted into `1` (and `false` is simply excluded).

## Acknowledgments

These are the projects that made `ecto_sqlite3_extras` possible:

1. [phoenix_live_dashboard](https://github.com/phoenixframework/phoenix_live_dashboard) is the reason why I made the project. I want my SQLite-powered Phoenix service to have the same nice-looking live dashboard as for PostgreSQL.
1. [exqlite](https://github.com/elixir-sqlite/exqlite) provides SQLite support for Elixir. They enabled just for me the `SQLITE_ENABLE_DBSTAT_VTAB` option required for `ecto_sqlite3_extras` to work, literally making this project possible.
1. [ecto_psql_extras](https://github.com/pawurb/ecto_psql_extras) is a similar project for PostgreSQL. I shamelessly copied the project structure and tests, so that I can be sure that `ecto_sqlite3_extras` can be a drop-in replacement for `ecto_psql_extras`.
