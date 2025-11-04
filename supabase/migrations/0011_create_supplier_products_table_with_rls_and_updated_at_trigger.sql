-- Create supplier_products table
CREATE TABLE public.supplier_products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  supplier_id UUID NOT NULL REFERENCES public.suppliers(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  cost_price NUMERIC,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE (supplier_id, product_id)
);

-- Enable RLS for supplier_products table
ALTER TABLE public.supplier_products ENABLE ROW LEVEL SECURITY;

-- Policies for supplier_products table
CREATE POLICY "Store managers can view supplier products" ON public.supplier_products
FOR SELECT TO authenticated USING (
  supplier_id IN (
    SELECT s.id FROM public.suppliers s
    WHERE s.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())
  )
);

CREATE POLICY "Store managers can insert supplier products" ON public.supplier_products
FOR INSERT TO authenticated WITH CHECK (
  supplier_id IN (
    SELECT s.id FROM public.suppliers s
    WHERE s.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())
  )
);

CREATE POLICY "Store managers can update supplier products" ON public.supplier_products
FOR UPDATE TO authenticated USING (
  supplier_id IN (
    SELECT s.id FROM public.suppliers s
    WHERE s.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())
  )
);

CREATE POLICY "Store managers can delete supplier products" ON public.supplier_products
FOR DELETE TO authenticated USING (
  supplier_id IN (
    SELECT s.id FROM public.suppliers s
    WHERE s.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())
  )
);

-- Add trigger for updated_at column
CREATE TRIGGER update_supplier_products_updated_at
BEFORE UPDATE ON public.supplier_products
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();