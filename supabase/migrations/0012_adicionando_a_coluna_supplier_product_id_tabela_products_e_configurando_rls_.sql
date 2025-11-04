ALTER TABLE public.products
ADD COLUMN supplier_product_id UUID REFERENCES public.supplier_products(id) ON DELETE SET NULL;

-- Adicionar política de UPDATE para permitir que usuários atualizem o supplier_product_id
CREATE POLICY "Users can update supplier_product_id in their store" ON public.products
FOR UPDATE TO authenticated
USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()))
WITH CHECK (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));