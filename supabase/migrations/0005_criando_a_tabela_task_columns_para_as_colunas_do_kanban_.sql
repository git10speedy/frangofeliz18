CREATE TABLE public.task_columns (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID REFERENCES public.stores(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.task_columns ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Store managers can view their task columns" ON public.task_columns
FOR SELECT TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can insert their task columns" ON public.task_columns
FOR INSERT TO authenticated WITH CHECK (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can update their task columns" ON public.task_columns
FOR UPDATE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can delete their task columns" ON public.task_columns
FOR DELETE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE TRIGGER update_task_columns_updated_at
BEFORE UPDATE ON public.task_columns
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();