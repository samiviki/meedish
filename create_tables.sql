-- RUN THIS ENTIRE SCRIPT IN THE SUPABASE SQL EDITOR --

-- 1. Create users table
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    full_name TEXT,
    company_name TEXT,
    role TEXT DEFAULT 'customer',
    status TEXT DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create machine_categories table
CREATE TABLE IF NOT EXISTS public.machine_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create machines table
CREATE TABLE IF NOT EXISTS public.machines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    partner_id UUID REFERENCES public.users(id),
    name TEXT NOT NULL,
    category TEXT REFERENCES public.machine_categories(name),
    brand TEXT,
    model TEXT,
    year INTEGER,
    status TEXT DEFAULT 'available',
    type TEXT,
    price_day NUMERIC,
    price_week NUMERIC,
    price_month NUMERIC,
    sale_price NUMERIC,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create orders table
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    machine_id UUID REFERENCES public.machines(id),
    buyer_id UUID REFERENCES public.users(id),
    seller_id UUID REFERENCES public.users(id),
    status TEXT DEFAULT 'pending',
    total_price NUMERIC,
    rental_days INTEGER,
    final_price NUMERIC,
    payment_status TEXT DEFAULT 'unpaid',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Create machine_inquiries table
CREATE TABLE IF NOT EXISTS public.machine_inquiries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    machine_id UUID REFERENCES public.machines(id),
    user_id UUID REFERENCES public.users(id),
    name TEXT,
    email TEXT,
    phone TEXT,
    message TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Create wishlist table
CREATE TABLE IF NOT EXISTS public.wishlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    machine_id UUID REFERENCES public.machines(id),
    user_email TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Create communications table
CREATE TABLE IF NOT EXISTS public.communications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id),
    user_id UUID REFERENCES public.users(id),
    type TEXT,
    subject TEXT,
    content TEXT,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Create negotiation_history table
CREATE TABLE IF NOT EXISTS public.negotiation_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id),
    user_id UUID REFERENCES public.users(id),
    stage TEXT,
    action TEXT,
    offered_price NUMERIC,
    counter_price NUMERIC,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- DISABLE ROW LEVEL SECURITY (RLS) FOR CUSTOM AUTHENTICATION
-- Because your application queries the tables directly using custom auth (checking the users table) 
-- rather than Supabase's built-in Auth, RLS policies relying on auth.uid() will block all requests.
-- We must disable RLS or set broad policies for the app to function properly.
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machine_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machines DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.machine_inquiries DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishlist DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.communications DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.negotiation_history DISABLE ROW LEVEL SECURITY;
