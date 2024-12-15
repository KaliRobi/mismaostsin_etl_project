{{ config(
    materialized='table',
    alias='app_users'
) }}

WITH app_users AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY client ORDER BY client  ) AS user_id,
        client AS user_name
    FROM {{ ref('stg_raw_shoping_details') }}
    GROUP BY client
)


SELECT * FROM app_users

