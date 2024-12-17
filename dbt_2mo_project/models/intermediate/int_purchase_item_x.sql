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
    JOIN {{ ref('stg_raw_shoping_details') }} rs ON rs.purchase_id = p.purchase_id
    JOIN {{ ref('int_item_model') }} i ON i.item_name = rs.item_name
    WHERE i.quantity = rs.quantity
    AND i.price = rs.price
)


Select * from purchase_items_x



