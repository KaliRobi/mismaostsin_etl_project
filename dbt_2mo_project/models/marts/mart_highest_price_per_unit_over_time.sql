With highest_price_per_unit AS 
(Select 
p.purchase_id
,g.name as goods_name
,ROUND(i.price/ i.quantity, 2) as cost_per_unit
,Row_number() OVER(Partition by p.purchase_id Order by ROUND(i.price/ i.quantity, 2) desc) as rank
,DATE_TRUNC('month', p.purchase_date)::DATE as purchase_date
from purchase p
join purchase_items_x px on px.purchase_id = p.id
join item i on px.item_id = i.id
join goods g on g.id = i.goods_id
order by p.purchase_id,)


select goods_name, cost_per_unit, purchase_date from highest_price_per_unit 
where rank = 1
order by  purchase_date, cost_per_unit desc;