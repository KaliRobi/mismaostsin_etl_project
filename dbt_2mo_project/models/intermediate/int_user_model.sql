{{ config(
    materialized='table',
    alias='app_users',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
) }}

WITH app_users AS (
    SELECT DISTINCT        
        client AS user_name
    FROM {{ ref('stg_raw_shoping_details') }}
    GROUP BY client
)


SELECT * FROM app_users

