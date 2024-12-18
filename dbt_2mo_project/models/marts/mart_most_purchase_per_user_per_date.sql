{{
    config(
        materialized='table',
        alias='most_purchase_per_user_per_date',
        post_hook='CREATE INDEX IF NOT EXISTS idx_most_purchase_per_user_per_date_user_id ON {{ this }}(user_name);'
    )
}}

With expense_per_month as (
Select 
u.user_name as user_name
, g.name as goods_name
, sum(i.quantity)  as quantity
, p.purchase_date as purchase_date
, Row_number() Over(Partition by u.user_name, purchase_date order by sum(i.quantity) desc) as rank
from app_users u 
join {{ref('int_purchases_model')}} p on p.user_id = u.id
join {{ref('int_purchase_items_x_model')}}  pix on pix.purchase_id = p.id
join {{ref('int_item_model')}} i  on i.id = pix.item_id
join {{ref('int_goods_model')}} g on g.id = i.goods_id
group by u.user_name ,p.purchase_date , g.name 
order by u.user_name, purchase_date, rank )

select *  from expense_per_month
where rank in (1,2,3,4)





