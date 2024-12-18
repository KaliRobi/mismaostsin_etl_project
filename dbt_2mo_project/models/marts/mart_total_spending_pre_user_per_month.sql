{{
    config(
        materialized='table',
        alias='total_spending_per_user_per_month',
        post_hook='CREATE INDEX IF NOT EXISTS idx_total_per_month_table_user_id ON {{ this }}(user_name);'
    )
}}


Select 
u.user_name
,extract(year from p.purchase_date) as purchase_year
,extract(month from p.purchase_date) as purchase_month
,SUM(i.price)
from app_users u 
join {{ref('int_purchases_model')}} p on p.user_id = u.id
join {{ref('int_purchase_items_x_model')}}  pix on pix.purchase_id = p.id
join {{ref('int_item_model')}} i  on i.id = pix.item_id
join {{ref('int_goods_model')}} g on g.id = i.goods_id
group by u.user_name,purchase_year, purchase_month
order by u.user_name, purchase_year, purchase_month