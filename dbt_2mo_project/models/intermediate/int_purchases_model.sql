{{config(
    materialized='table',
    alias='purchase'
    )
}}

WITH user_ids AS (
        SELECT 
        user_id,
        user_name
        FROM {{ ref('int_user_model')}}
)


SELECT 
    purchase_id,
    u.user_id,
    purchase_date,
    COUNT(price) as total_cost    
    FROM {{ ref('stg_raw_shoping_details') }} s 
    JOIN user_ids u ON u.user_name = s.user_name
    GROUP BY purchase_id, user_id, purchase_date


