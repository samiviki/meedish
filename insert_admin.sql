-- Turn off RLS for the users table so the app can query it
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- Insert the super admin account
INSERT INTO public.users (email, password, full_name, role, status)
VALUES (
    'admin@example.com', 
    'admin123',
    'Super Admin', 
    'super_admin', 
    'active'
);
