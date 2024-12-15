{{ config(
    materialized='table',
    alias='goods'
) }}

SELECT DISTINCT 
ROW_NUMBER() OVER( PARTITION BY goods_name ORDER BY goods_name) AS id,
goods_name
FROM {{ ref('stg_raw_shoping_details') }}
GROUP BY goods_name