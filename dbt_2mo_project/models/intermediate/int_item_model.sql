{{
config(
    materialized='table',
    alias = 'item',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
    )
}}


SELECT DISTINCT
    item_name,
    amount,
    price
FROM  {{ ref('stg_raw_shoping_details') }}



