-- Enable Row Level Security on orders table
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
-- Revoke broad grants and use owner-based RLS policies
REVOKE ALL ON public.orders FROM anon;
REVOKE ALL ON public.orders FROM authenticated;

-- Drop any existing broad policies
DROP POLICY IF EXISTS "Enable read access for all users" ON public.orders;
DROP POLICY IF EXISTS "Enable insert for all users" ON public.orders;

-- Allow users to SELECT orders where they are buyer or seller
CREATE POLICY "Select orders for owners"
ON public.orders
FOR SELECT
TO authenticated
USING (buyer_id = auth.uid() OR seller_id = auth.uid());

-- Allow users to INSERT orders only when buyer_id matches their auth.uid()
CREATE POLICY "Insert orders as buyer"
ON public.orders
FOR INSERT
TO authenticated
WITH CHECK (buyer_id = auth.uid());

-- Allow updates by buyer or seller (or admin via separate policy)
CREATE POLICY "Update orders for owners"
ON public.orders
FOR UPDATE
TO authenticated
USING (buyer_id = auth.uid() OR seller_id = auth.uid())
WITH CHECK (buyer_id = auth.uid() OR seller_id = auth.uid());

-- Admins: create an admin role policy later if you manage roles via JWT custom claims
