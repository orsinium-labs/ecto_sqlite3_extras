# Ecto SQLite3 Extras

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_sqlite3_extras` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_sqlite3_extras, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_sqlite3_extras](https://hexdocs.pm/ecto_sqlite3_extras).

## Available queries

1. `table_size`.
    1. `name`:
    1. `payload_size`:
    1. `unused_size`:
    1. `page_size`:
    1. `cell_count`:
    1. `page_count`:
    1. `max_payload_size`:
1. `index_size`.
1. `sequence_number`.
    1. `table_name`:
    1. `sequence_number`:
1. `settings`. List values of PRAGMAs (settings). Only includes the ones that have an integer or a boolean value. For bravity, the ones with `0` (`false`) value are excluded from the output (based on the observation that this is the default value for most of the PRAGMAs). Check out the SQLite documentation to learn more about what each PRAGMA means: [PRAGMA Statements](https://www.sqlite.org/pragma.html).
    1. `name`: the name of the PRAGMA as listed in the SQLite documentation.
    1. `value`: the value of the PRAGMA. The `true` value is converted into `1` (and `false` is simply excluded).
