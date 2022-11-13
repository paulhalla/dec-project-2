with raw_source as (

    select *
    from {{ source('github_airflow', 'pull_requests_auto_merge_enabled_by') }}

),

final as (

    select
        "_AIRBYTE_AUTO_MERGE_HASHID"::VARCHAR as airbyte_auto_merge_hashid,
        "ID"::NUMBER as id,
        "URL"::VARCHAR as url,
        "TYPE"::VARCHAR as type,
        "LOGIN"::VARCHAR as login,
        "NODE_ID"::VARCHAR as node_id,
        "HTML_URL"::VARCHAR as html_url,
        "GISTS_URL"::VARCHAR as gists_url,
        "REPOS_URL"::VARCHAR as repos_url,
        "AVATAR_URL"::VARCHAR as avatar_url,
        "EVENTS_URL"::VARCHAR as events_url,
        "SITE_ADMIN"::BOOLEAN as site_admin,
        "GRAVATAR_ID"::VARCHAR as gravatar_id,
        "STARRED_URL"::VARCHAR as starred_url,
        "FOLLOWERS_URL"::VARCHAR as followers_url,
        "FOLLOWING_URL"::VARCHAR as following_url,
        "ORGANIZATIONS_URL"::VARCHAR as organizations_url,
        "SUBSCRIPTIONS_URL"::VARCHAR as subscriptions_url,
        "RECEIVED_EVENTS_URL"::VARCHAR as received_events_url,
        "_AIRBYTE_AB_ID"::VARCHAR as airbyte_ab_id,
        "_AIRBYTE_EMITTED_AT"::TIMESTAMP_TZ as airbyte_emitted_at,
        "_AIRBYTE_NORMALIZED_AT"::TIMESTAMP_TZ as airbyte_normalized_at,
        "_AIRBYTE_ENABLED_BY_HASHID"::VARCHAR as airbyte_enabled_by_hashid

    from raw_source

)

select * from final