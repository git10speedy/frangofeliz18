-- Create suppliers table
CREATE TABLE public.suppliers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
  corporate_name TEXT NOT NULL,
  cnpj TEXT UNIQUE,
  address TEXT,
  phone TEXT,
  whatsapp TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for suppliers table
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;

-- Policies for suppliers table
CREATE POLICY "Store managers can view their suppliers" ON public.suppliers
FOR SELECT TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can insert their suppliers" ON public.suppliers
FOR INSERT TO authenticated WITH CHECK (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can update their suppliers" ON public.suppliers
FOR UPDATE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can delete their suppliers" ON public.suppliers
FOR DELETE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

-- Add trigger for updated_at column
CREATE TRIGGER update_suppliers_updated_at
BEFORE UPDATE ON public.suppliers
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();