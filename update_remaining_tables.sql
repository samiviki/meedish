-- Update machine_inquiries table with missing columns from frontend
ALTER TABLE public.machine_inquiries 
    ADD COLUMN IF NOT EXISTS machine_type TEXT,
    ADD COLUMN IF NOT EXISTS listing_type TEXT,
    ADD COLUMN IF NOT EXISTS brand_preference TEXT,
    ADD COLUMN IF NOT EXISTS model_year TEXT,
    ADD COLUMN IF NOT EXISTS min_price NUMERIC,
    ADD COLUMN IF NOT EXISTS max_price NUMERIC,
    ADD COLUMN IF NOT EXISTS specifications TEXT,
    ADD COLUMN IF NOT EXISTS start_date TEXT,
    ADD COLUMN IF NOT EXISTS duration TEXT,
    ADD COLUMN IF NOT EXISTS notes TEXT;

-- We should also rename or make sure 'message' isn't conflicting, but the frontend sends 'notes' instead of 'message'.
-- So 'notes' is correct.

-- Update users table with missing location column
ALTER TABLE public.users 
    ADD COLUMN IF NOT EXISTS location JSONB;
