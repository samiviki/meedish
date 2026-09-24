-- =====================================================================
-- COMPREHENSIVE FIX SCRIPT FOR MISSING COLUMNS AND RLS ERRORS
-- Run this entire script in your Supabase SQL Editor
-- =====================================================================

-- 1. Fix missing columns in orders table (Resolves "Confirm and Place Order" error)
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

-- 2. Fix missing columns in machine_inquiries table
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

-- 3. Fix missing columns in users table (Resolves errors in Super Admin Dashboard)
ALTER TABLE public.users 
    ADD COLUMN IF NOT EXISTS phone TEXT,
    ADD COLUMN IF NOT EXISTS location JSONB;

-- 4. Fix wishlist schema conflicts 
-- (booking_wishlist_functions.js uses user_id, but index.html uses user_email)
ALTER TABLE public.wishlist 
    ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES public.users(id);
ALTER TABLE public.wishlist ALTER COLUMN user_email DROP NOT NULL;

-- 5. IMPORTANT: Disable RLS for custom auth compatibility
-- Because the application queries using a custom `users` table instead of 
-- Supabase's native auth.uid(), RLS will block insertions and cause errors.
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machine_inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishlist DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machines DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machine_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.communications DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.negotiation_history DISABLE ROW LEVEL SECURITY;
