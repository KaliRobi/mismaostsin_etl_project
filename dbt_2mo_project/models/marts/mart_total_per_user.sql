{{
    config(
        materialized='table',
        alias='total_spending_per_user',
        post_hook='CREATE INDEX IF NOT EXISTS idx_total_per_week_table_user_id ON {{ this }}(user_name);'
    )
}}


Select 
u.user_name
,SUM(i.price)
from {{ref('int_user_model')}} u 
join {{ref('int_purchases_model')}} p on p.user_id = u.id
join {{ref('int_purchase_items_x_model')}}  pix on pix.purchase_id = p.id
join {{ref('int_item_model')}} i  on i.id = pix.item_id
join {{ref('int_goods_model')}} g on g.id = i.goods_id
group by u.user_name
