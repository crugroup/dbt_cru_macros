-- Add to pre-hooks if using iceberg
{% macro bronze_iceberg_table_pre_hook(database, schema, table_name) -%}
create iceberg table if not exists {{ database|upper }}.{{ schema|upper }}.{{ table_name|upper }}
    catalog = {{ database|upper }}__{{ schema|upper }}
    external_volume = 'POLARIS'
    catalog_table_name = '{{ table_name|upper }}';

alter iceberg table {{ database|upper }}.{{ schema|upper }}.{{ table_name|upper }} refresh;
{%- endmacro %}
