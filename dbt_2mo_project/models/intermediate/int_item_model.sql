{{
config(
    materialized='table',
    alias = 'item',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
    )
}}


SELECT DISTINCT
    ig.id AS goods_id,
    quantity,
    price
FROM  {{ ref('stg_raw_shoping_details') }} rs
JOIN {{ref('int_goods_model')}} ig on ig.name = rs.item_name



