{% set schema_names=('github_airflow', 'github_argo', 'github_dagster', 'github_luigi', 'github_orchest', 'github_prefect') %}

with stg_issues as (

    {% for schema in schema_names %}
    select
        "_AIRBYTE_UNIQUE_KEY"::VARCHAR as airbyte_unique_key,
        "ID"::NUMBER as id,
        -- "URL"::VARCHAR as url,
        "BODY"::VARCHAR as body,
        "USER"::VARIANT as user,
        -- "STATE"::VARCHAR as state,
        "TITLE"::VARCHAR as title,
        "LABELS"::VARIANT as labels,
        "LOCKED"::BOOLEAN as locked,
        -- "NUMBER"::NUMBER as number,
        -- "NODE_ID"::VARCHAR as node_id,
        -- "USER_ID"::NUMBER as user_id,
        -- "ASSIGNEE"::VARIANT as assignee,
        -- "COMMENTS"::NUMBER as comments,
        -- "HTML_URL"::VARCHAR as html_url,
        -- "ASSIGNEES"::VARIANT as assignees,
        -- "CLOSED_AT"::TIMESTAMP_TZ as closed_at,
        -- "MILESTONE"::VARIANT as milestone,
        -- "CREATED_AT"::TIMESTAMP_TZ as created_at,
        -- "EVENTS_URL"::VARCHAR as events_url,
        -- "LABELS_URL"::VARCHAR as labels_url,
        "REPOSITORY"::VARCHAR as repository,
        "UPDATED_AT"::TIMESTAMP_TZ as updated_at,
        -- "COMMENTS_URL"::VARCHAR as comments_url,
        "PULL_REQUEST"::VARIANT as pull_request,
        "REPOSITORY_URL"::VARCHAR as repository_url,
        -- "ACTIVE_LOCK_REASON"::VARCHAR as active_lock_reason,
        "AUTHOR_ASSOCIATION"::VARCHAR as author_association
        -- "_AIRBYTE_AB_ID"::VARCHAR as airbyte_ab_id,
        -- "_AIRBYTE_EMITTED_AT"::TIMESTAMP_TZ as airbyte_emitted_at,
        -- "_AIRBYTE_NORMALIZED_AT"::TIMESTAMP_TZ as airbyte_normalized_at,
        -- "_AIRBYTE_ISSUES_HASHID"::VARCHAR as airbyte_issues_hashid

    from {{ source(schema|string, 'issues')}}

    {% if not loop.last %}

    union all
    {% endif %}
    {% endfor %}

)

select * from stg_issues
