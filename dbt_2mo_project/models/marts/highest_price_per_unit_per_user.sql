With highest_price_per_unit_per_user AS 
(Select 
 au.user_name
,p.purchase_id
,g.name as goods_name
,ROUND(i.price/ i.quantity, 2) as cost_per_unit
,DATE_TRUNC('month', p.purchase_date)::DATE as purchase_date
,Row_number() OVER(Partition by au.user_name, purchase_date Order by ROUND(i.price/ i.quantity, 2) desc) as rank
from {{ref('int_purchases_model')}}  p
join {{ref('int_purchase_items_x_model')}}   px on px.purchase_id = p.id
join {{ref('int_item_model')}} i on px.item_id = i.id
join {{ref('int_goods_model')}}  g on g.id = i.goods_id
join {{ref('int_user_model')}}  au on au.id = p.user_id
order by au.user_name, rank)


select 
user_name
,goods_name
,cost_per_unit
,purchase_date
from highest_price_per_unit_per_user
where rank = 1
order by user_name,  purchase_date desc
