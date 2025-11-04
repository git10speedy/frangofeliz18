-- Create system_settings table
CREATE TABLE public.system_settings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  is_subscription_active BOOLEAN DEFAULT FALSE NOT NULL,
  monthly_price NUMERIC DEFAULT 0.00 NOT NULL,
  annual_price NUMERIC DEFAULT 0.00 NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (REQUIRED for security)
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- Policies for system_settings
-- Admins can manage (insert, update, delete) system settings
CREATE POLICY "Admins can manage system settings" ON public.system_settings
FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- All authenticated users can read system settings (UI will filter display)
CREATE POLICY "Authenticated users can read system settings" ON public.system_settings
FOR SELECT TO authenticated USING (true);

-- Insert a default row if the table is empty (for initial setup)
INSERT INTO public.system_settings (is_subscription_active, monthly_price, annual_price)
SELECT FALSE, 0.00, 0.00
WHERE NOT EXISTS (SELECT 1 FROM public.system_settings);

-- Add trigger to update updated_at column
CREATE TRIGGER update_system_settings_updated_at
BEFORE UPDATE ON public.system_settings
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();