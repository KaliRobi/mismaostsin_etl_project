{{config(
    materialized='table',
    alias='int_purchase',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
    )
}}

WITH user_ids AS (
        SELECT 
        id,
        user_name
        FROM {{ ref('int_user_model')}}
)


SELECT 
    purchase_id,
    u.id AS user_id,
    purchase_date,
    COUNT(price) as total_cost    
    FROM {{ ref('stg_raw_shoping_details') }} s 
    JOIN user_ids u ON u.user_name = s.client
    GROUP BY purchase_id, u.id, purchase_date


