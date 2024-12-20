With highest_price_per_unit AS 
(Select 
p.purchase_id
,g.name as goods_name
,ROUND(i.price/ i.quantity, 2) as cost_per_unit
,Row_number() OVER(Partition by p.purchase_id Order by ROUND(i.price/ i.quantity, 2) desc) as rank
,DATE_TRUNC('month', p.purchase_date)::DATE as purchase_date
from {{ref('int_purchases_model')}}  p
join {{ref('int_purchase_items_x_model')}}   px on px.purchase_id = p.id
join {{ref('int_item_model')}} i on px.item_id = i.id
join {{ref('int_goods_model')}}  g on g.id = i.goods_id
order by p.purchase_id)


select
 goods_name
,cost_per_unit
,purchase_date
 from highest_price_per_unit 
where rank = 1
order by  purchase_date, cost_per_unit desc

