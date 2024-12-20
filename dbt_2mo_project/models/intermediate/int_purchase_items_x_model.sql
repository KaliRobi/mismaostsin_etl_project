{{
    config(
        materialized='table',
        alias='int_purchase_items_x'

    )
}}


With purchase_items_x AS (
    Select
    p.id AS purchase_id,
    i.id AS item_id
    FROM {{ref('int_purchases_model')}} p 
    JOIN {{ ref('stg_raw_shoping_details') }} rs ON rs.purchase_id = p.purchase_id
    JOIN {{ ref('int_goods_model')}} g on g.name = rs.item_name
    JOIN {{ ref('int_item_model') }} i ON i.goods_id = g.id
    WHERE i.quantity = rs.quantity
    AND i.price = rs.price
)


Select * from purchase_items_x



