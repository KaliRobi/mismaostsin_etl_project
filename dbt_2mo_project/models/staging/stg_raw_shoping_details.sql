WITH purchases_with_date AS (
SELECT
    goods_name AS item_name,
    purchase_id,
    amount,
    price,
    DATE(insert_time) AS purchase_date,
    client
FROM {{source('raw_data', 'raw_shopping_details') }}
WHERE insert_time IS NOT NULL
AND client IS NOT NULL
)

SELECT * FROM purchases_with_date


