{#
  Selects every column from `relation`, quoting the original identifier and
  aliasing it to a fully snake_case, lowercase name.

  - Spaces, hyphens and dots are replaced with underscores.
  - All letters are lowercased.
  - Consecutive underscores are collapsed to a single underscore.
  - The original column name is always quoted so that case-sensitive identifiers
    from Snowflake data shares are handled correctly.

  Usage:
    SELECT
        {{ dbt_cru_macros.snake_case_columns(source('source', 'MY_TABLE')) }}
    FROM {{ source('source', 'MY_TABLE') }}
#}
{% macro snake_case_columns(relation) -%}
    {%- if execute -%}
        {%- set columns = adapter.get_columns_in_relation(relation) -%}
    {%- else -%}
        {%- set columns = [] -%}
    {%- endif -%}
    {%- set col_exprs = [] -%}
    {%- for col in columns -%}
        {%- set orig = col.column -%}
        {%- set snake = orig | lower | replace(' ', '_') | replace('-', '_') | replace('.', '_') -%}
        {%- set snake = snake | replace('__', '_') | replace('__', '_') -%}
        {%- do col_exprs.append(adapter.quote(orig) ~ ' AS ' ~ snake) -%}
    {%- endfor -%}
    {{ col_exprs | join(',\n    ') }}
{%- endmacro %}
