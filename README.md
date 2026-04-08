# dbt_cru_macros

A general-purpose dbt macro package by CRU, intended for dbt projects targeting Snowflake.

## Installation

Add the following to your project's `packages.yml`:

```yaml
packages:
  - tarball: https://github.com/crugroup/dbt_cru_macros/archive/refs/tags/v0.2.1.tar.gz
    name: 'dbt_cru_macros'
```

Then run:

```bash
dbt deps
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
pip install pre-commit sqlfluff dbt-core dbt-snowflake
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
3. Add/update the corresponding yml file to sync documentation.
4. Ensure all pre-commit hooks pass before opening a pull request.

---

## License

See [LICENSE](LICENSE) for details.
