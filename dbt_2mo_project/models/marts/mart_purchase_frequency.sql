{{
    config(
        materialized='table',
        alias='purchase_frequency',
        post_hook='CREATE INDEX IF NOT EXISTS idx_purchase_frequency ON {{ this }}(user_name);'
    )
}}

Select user_name, purchase_date from {{ref('int_user_model')}} au
join {{ref('int_purchases_model')}}  p on p.user_id = au.id
order by user_name, purchase_date