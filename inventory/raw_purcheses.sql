CREATE TABLE IF NOT EXISTS public.raw_shopping_details
(
    id SERIAL PRIMARY KEY,
    purchase_id VARCHAR(36) NOT NULL,
    goods_name VARCHAR(40) NOT NULL,
    quantity NUMERIC(10,2),
    price NUMERIC(10,2) NOT NULL,
    insert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    client VARCHAR(50) NOT NULL
);


CREATE INDEX IF NOT EXISTS idx_purchase_id  ON public.raw_shopping_details (purchase_id);