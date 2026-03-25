# dbt_cru_macros

A general-purpose dbt macro package by CRU, intended for dbt projects targeting Snowflake.

## Installation

Add the following to your project's `packages.yml`:

```yaml
packages:
  - git: https://github.com/crugroup/cru_dbt_macros
    revision: main
```

Then run:

```bash
dbt deps
```

---

## Macros

### `create_bronze_iceberg_table`

Creates a Snowflake-managed Iceberg table in the bronze layer if it does not already exist. The table is backed by a Polaris external volume and registered in the specified Iceberg catalog.

Add this macro as a `pre-hook` on dbt models that write to Iceberg-format bronze tables.

**Arguments**

| Argument     | Type   | Description |
|--------------|--------|-------------|
| `catalog`    | string | The Iceberg catalog registered in Snowflake (e.g. `'MY_POLARIS_CATALOG'`). |
| `database`   | string | The Snowflake database where the table will be created (e.g. `'bronze_assets'`). |
| `schema`     | string | The schema within that database (e.g. `'raw_ingest'`). |
| `table_name` | string | The name of the Iceberg table. Also used as the `catalog_table_name`. |

**Example**

In `dbt_project.yml`:

```yaml
models:
  my_project:
    bronze:
      +pre-hook: "{{ dbt_cru_macros.create_bronze_iceberg_table('MY_POLARIS_CATALOG', 'bronze_assets', 'raw_ingest', this.name) }}"
```

Generated SQL:

```sql
create iceberg table if not exists bronze_assets.raw_ingest.my_table
    catalog = MY_POLARIS_CATALOG
    external_volume = 'POLARIS'
    catalog_table_name = 'my_table'
```

---

### `update_bronze_iceberg_table`

Refreshes the metadata of an existing Snowflake-managed Iceberg table in the bronze layer. Issues an `ALTER ICEBERG TABLE … REFRESH` statement to synchronise Snowflake's view of the table with the latest snapshot written to the Polaris external volume.

Add this macro as a `pre-hook` on dbt models that read from Iceberg-format bronze tables.

**Arguments**

| Argument     | Type   | Description |
|--------------|--------|-------------|
| `catalog`    | string | The Iceberg catalog registered in Snowflake. Kept for API consistency with `create_bronze_iceberg_table`. |
| `database`   | string | The Snowflake database containing the Iceberg table (e.g. `'bronze_assets'`). |
| `schema`     | string | The schema within that database (e.g. `'raw_ingest'`). |
| `table_name` | string | The name of the Iceberg table to refresh. |

**Example**

In `dbt_project.yml`:

```yaml
models:
  my_project:
    staging:
      +pre-hook: "{{ dbt_cru_macros.update_bronze_iceberg_table('MY_POLARIS_CATALOG', 'bronze_assets', 'raw_ingest', 'my_table') }}"
```

Generated SQL:

```sql
alter iceberg table bronze_assets.raw_ingest.my_table refresh
```

---

## Development

### Prerequisites

- Python ≥ 3.11
- [pre-commit](https://pre-commit.com/)
- [SQLFluff](https://sqlfluff.com/) with Snowflake dialect
- [dbt-core](https://docs.getdbt.com/)

### Setup

```bash
pip install pre-commit sqlfluff dbt-core
pre-commit install
```

### Linting

```bash
sqlfluff lint macros/
sqlfluff fix macros/
pre-commit run --all-files
```

---

## Contributing

1. Fork the repository and create a feature branch.
2. Add or modify macros inside `macros/`.
3. Update `macros/macros.yml` with descriptions and argument documentation for every macro.
4. Update this README with usage examples.
5. Ensure all pre-commit hooks pass before opening a pull request.

---

## License

See [LICENSE](LICENSE) for details.
