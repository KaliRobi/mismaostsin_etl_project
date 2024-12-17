{{
    config(
        materialized='table',
        alias='purchase_items_x'
        
    )
}}


With purchase_items_x AS (
    Select
    p.id AS purchase_id,
    i.id AS item_id
    FROM {{ref('int_purchases_model')}} p 
    JOIN {{ ref('stg_raw_shoping_details') }} sh ON sh.purchase_id = p.purchase_id
    JOIN {{ ref('int_item_model') }} i ON i.item_name = sh.item_name
)


Select * from purchase_items_x