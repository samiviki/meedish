-- Add the missing columns to the machines table that the frontend app expects
ALTER TABLE public.machines 
    ADD COLUMN IF NOT EXISTS listing_type TEXT,
    ADD COLUMN IF NOT EXISTS condition TEXT,
    ADD COLUMN IF NOT EXISTS safety_notes TEXT,
    ADD COLUMN IF NOT EXISTS common_details JSONB,
    ADD COLUMN IF NOT EXISTS rental_terms JSONB,
    ADD COLUMN IF NOT EXISTS specific_details JSONB,
    ADD COLUMN IF NOT EXISTS image_urls JSONB,
    ADD COLUMN IF NOT EXISTS price NUMERIC;
