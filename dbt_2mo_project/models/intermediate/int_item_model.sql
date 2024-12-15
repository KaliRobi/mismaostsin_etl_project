{{
config(
    materialized='table',
    alias = 'item')
}}


SELECT DISTINCT
    ROW_NUMBER() OVER( PARTITION BY item ORDER BY item) AS id,
    item_name


FROM FROM {{ ref('stg_raw_shoping_details') }}