{% set schema_names=('github_airflow', 'github_argo', 'github_dagster', 'github_luigi', 'github_orchest', 'github_prefect') %}

with stg_pull_requests_assignee as (
    
    {% for schema in schema_names %}


    select
        "_AIRBYTE_PULL_REQUESTS_HASHID"::VARCHAR as airbyte_pull_requests_hashid,
        "ID"::NUMBER as id,
        -- "URL"::VARCHAR as url,
        "TYPE"::VARCHAR as type,
        "LOGIN"::VARCHAR as login
        -- "NODE_ID"::VARCHAR as node_id,
        -- "HTML_URL"::VARCHAR as html_url,
        -- "GISTS_URL"::VARCHAR as gists_url,
        -- "REPOS_URL"::VARCHAR as repos_url,
        -- "AVATAR_URL"::VARCHAR as avatar_url,
        -- "EVENTS_URL"::VARCHAR as events_url,
        -- "SITE_ADMIN"::BOOLEAN as site_admin,
        -- "GRAVATAR_ID"::VARCHAR as gravatar_id,
        -- "STARRED_URL"::VARCHAR as starred_url,
        -- "FOLLOWERS_URL"::VARCHAR as followers_url,
        -- "FOLLOWING_URL"::VARCHAR as following_url,
        -- "ORGANIZATIONS_URL"::VARCHAR as organizations_url,
        -- "SUBSCRIPTIONS_URL"::VARCHAR as subscriptions_url,
        -- "RECEIVED_EVENTS_URL"::VARCHAR as received_events_url,
        -- "_AIRBYTE_AB_ID"::VARCHAR as airbyte_ab_id,
        -- "_AIRBYTE_EMITTED_AT"::TIMESTAMP_TZ as airbyte_emitted_at,
        -- "_AIRBYTE_NORMALIZED_AT"::TIMESTAMP_TZ as airbyte_normalized_at,
        -- "_AIRBYTE_ASSIGNEE_HASHID"::VARCHAR as airbyte_assignee_hashid

    from {{ source(schema|string, 'pull_requests_assignee') }}

    {% if not loop.last %}

    union all

    {% endif %}
    {% endfor %}

)

select * from stg_pull_requests_assignee
