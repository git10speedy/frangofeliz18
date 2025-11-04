CREATE TABLE public.tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID REFERENCES public.stores(id) ON DELETE CASCADE NOT NULL,
  column_id UUID REFERENCES public.task_columns(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL,
  is_recurring BOOLEAN DEFAULT FALSE NOT NULL,
  recurrence_interval TEXT, -- e.g., 'monthly', 'weekly'
  last_recurrence_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Store managers can view their tasks" ON public.tasks
FOR SELECT TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can insert their tasks" ON public.tasks
FOR INSERT TO authenticated WITH CHECK (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can update their tasks" ON public.tasks
FOR UPDATE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Store managers can delete their tasks" ON public.tasks
FOR DELETE TO authenticated USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE TRIGGER update_tasks_updated_at
BEFORE UPDATE ON public.tasks
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();