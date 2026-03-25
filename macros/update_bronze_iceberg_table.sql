-- Add to pre-hooks if using iceberg
{% macro update_bronze_iceberg_table(catalog, database, schema, table_name) -%}
    alter iceberg table {{ database }}.{{ schema }}.{{ table_name }} refresh
{%- endmacro %}
