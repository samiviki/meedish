-- Add the missing columns to the orders table that the frontend app expects
ALTER TABLE public.orders 
    ADD COLUMN IF NOT EXISTS order_number TEXT,
    ADD COLUMN IF NOT EXISTS machine_data JSONB,
    ADD COLUMN IF NOT EXISTS customer_name TEXT,
    ADD COLUMN IF NOT EXISTS customer_email TEXT,
    ADD COLUMN IF NOT EXISTS customer_phone TEXT,
    ADD COLUMN IF NOT EXISTS customer_company TEXT,
    ADD COLUMN IF NOT EXISTS customer_address TEXT,
    ADD COLUMN IF NOT EXISTS original_price NUMERIC,
    ADD COLUMN IF NOT EXISTS counter_offer_price NUMERIC,
    ADD COLUMN IF NOT EXISTS counter_offer_notes TEXT,
    ADD COLUMN IF NOT EXISTS fuel_option TEXT,
    ADD COLUMN IF NOT EXISTS delivery_option TEXT,
    ADD COLUMN IF NOT EXISTS delivery_date TEXT,
    ADD COLUMN IF NOT EXISTS delivery_time TEXT,
    ADD COLUMN IF NOT EXISTS delivery_instructions TEXT,
    ADD COLUMN IF NOT EXISTS partner_id UUID REFERENCES public.users(id);
