-- Enable Row Level Security (just in case)
ALTER TABLE public.machine_inquiries ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts/errors
DROP POLICY IF EXISTS "Allow public submission" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow authenticated submission" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow admin to view inquiries" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow admin to update inquiries" ON public.machine_inquiries;

-- Only authenticated users may insert inquiries and inserts must set user_id = auth.uid()
REVOKE ALL ON public.machine_inquiries FROM anon;
REVOKE ALL ON public.machine_inquiries FROM authenticated;

DROP POLICY IF EXISTS "Allow public submission" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow authenticated submission" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow admin to view inquiries" ON public.machine_inquiries;
DROP POLICY IF EXISTS "Allow admin to update inquiries" ON public.machine_inquiries;

CREATE POLICY "Insert inquiry authenticated"
ON public.machine_inquiries
FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Allow owners to SELECT their inquiries
CREATE POLICY "Select own inquiries"
ON public.machine_inquiries
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Allow owners to UPDATE their own inquiries
CREATE POLICY "Update own inquiries"
ON public.machine_inquiries
FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Consider an admin policy if you manage admin role via JWT claims
