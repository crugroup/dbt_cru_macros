{% macro create_semantic_view(database, schema, view_name, yaml) %}
    {# Create schema for Cortex Analyst semantic models #}
    create schema if not exists {{ database|upper }}.{{ schema|upper }};

    {# Check if semantic view already exists #}
    {% set check_view_query %}
        select count(*) as view_count
        from {{ database|upper }}.INFORMATION_SCHEMA.SEMANTIC_VIEWS
        where name = '{{ view_name|upper }}'
    {% endset %}

    {% set results = run_query(check_view_query) %}

    {% if execute %}
        {% set view_exists = results.columns[0].values()[0] > 0 %}

        {% if not view_exists %}
            {{ log("Creating semantic view {{ view_name|upper }} in {{ database|upper }}.{{ schema|upper }}.", info=True) }}
             {# Create semantic view from YAML definition #}
            call system$create_semantic_view_from_yaml(
                '{{ database|upper }}.{{ schema|upper }}',
                $$
                {{ yaml }}
                $$
            );
        {% else %}
            {{ log("Semantic view {{ view_name|upper }} already exists in {{ database|upper }}.{{ schema|upper }}.", info=True) }}
        {% endif %}
    {% endif %}
{% endmacro %}