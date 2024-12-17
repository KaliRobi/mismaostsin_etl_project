{{ config(
    materialized='table',
    alias='goods',
    post_hook="ALTER TABLE {{ this }} ADD COLUMN id SERIAL PRIMARY KEY;"
) }}

SELECT DISTINCT 
item_name
FROM {{ ref('stg_raw_shoping_details') }}
GROUP BY item_name