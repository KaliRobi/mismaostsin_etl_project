{{ config(
    materialized='table',
    alias='int_goods',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
) }}

SELECT DISTINCT 
item_name AS name
FROM {{ ref('stg_raw_shoping_details') }}
