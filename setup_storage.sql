-- 1. Create the 'machine-images' storage bucket (and make it public for viewing)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('machine-images', 'machine-images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Create security policies to allow public access (since your app uses custom auth)
-- Allow anyone to view images
CREATE POLICY "Public Access" 
ON storage.objects FOR SELECT 
USING ( bucket_id = 'machine-images' );

-- Allow anyone to upload images
CREATE POLICY "Public Uploads" 
ON storage.objects FOR INSERT 
WITH CHECK ( bucket_id = 'machine-images' );

-- Allow anyone to update/delete images
CREATE POLICY "Public Updates" 
ON storage.objects FOR UPDATE 
USING ( bucket_id = 'machine-images' );

CREATE POLICY "Public Deletes" 
ON storage.objects FOR DELETE 
USING ( bucket_id = 'machine-images' );
