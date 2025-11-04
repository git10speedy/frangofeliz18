ALTER TABLE public.stores
ADD COLUMN ifood_stock_alert_threshold INTEGER DEFAULT 0;

-- Add RLS policy for update on the new column
CREATE POLICY "Store managers can update their ifood stock alert threshold" ON public.stores
FOR UPDATE TO authenticated USING (id IN ( SELECT profiles.store_id
   FROM profiles
  WHERE (profiles.id = auth.uid()))) WITH CHECK (id IN ( SELECT profiles.store_id
   FROM profiles
  WHERE (profiles.id = auth.uid())));