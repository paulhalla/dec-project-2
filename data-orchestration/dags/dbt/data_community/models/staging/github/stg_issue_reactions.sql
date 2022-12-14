{% set schema_names=('github_airflow', 'github_argo', 'github_dagster', 'github_luigi', 'github_orchest', 'github_prefect') %}

with stg_issue_reactions as (

    {% for schema in schema_names %}
    select
        "_AIRBYTE_UNIQUE_KEY"::VARCHAR as airbyte_unique_key,
        "ID"::NUMBER as id,
        "USER"::VARIANT as user,
        "CONTENT"::VARCHAR as content,
        -- "NODE_ID"::VARCHAR as node_id,
        "CREATED_AT"::TIMESTAMP_TZ as created_at,
        "REPOSITORY"::VARCHAR as repository,
        "ISSUE_NUMBER"::NUMBER as issue_number
        -- "_AIRBYTE_AB_ID"::VARCHAR as airbyte_ab_id,
        -- "_AIRBYTE_EMITTED_AT"::TIMESTAMP_TZ as airbyte_emitted_at,
        -- "_AIRBYTE_NORMALIZED_AT"::TIMESTAMP_TZ as airbyte_normalized_at,
        -- "_AIRBYTE_ISSUE_REACTIONS_HASHID"::VARCHAR as airbyte_issue_reactions_hashid

    from {{ source(schema|string, 'issue_reactions') }}

    {% if not loop.last %}

    union all
    {% endif %}
    {% endfor %}
)

select * from stg_issue_reactions
