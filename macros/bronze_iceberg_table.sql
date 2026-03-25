-- Add to pre-hooks if using iceberg
{% macro create_bronze_iceberg_table(catalog, database, schema, table_name) -%}
    create iceberg table if not exists {{ database }}.{{ schema }}.{{ table_name }}
    catalog = {{ catalog }}
    external_volume = 'POLARIS'
    catalog_table_name = '{{ table_name }}'
{%- endmacro %}

{% macro update_bronze_iceberg_table(catalog, database, schema, table_name) -%}
    alter iceberg table {{ database }}.{{ schema }}.{{ table_name }} refresh
{%- endmacro %}
