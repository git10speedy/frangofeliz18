CREATE TABLE public.task_checklist_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE NOT NULL,
  text TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE NOT NULL,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.task_checklist_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Store managers can view their task checklist items" ON public.task_checklist_items
FOR SELECT TO authenticated USING (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE POLICY "Store managers can insert their task checklist items" ON public.task_checklist_items
FOR INSERT TO authenticated WITH CHECK (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE POLICY "Store managers can update their task checklist items" ON public.task_checklist_items
FOR UPDATE TO authenticated USING (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE POLICY "Store managers can delete their task checklist items" ON public.task_checklist_items
FOR DELETE TO authenticated USING (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE TRIGGER update_task_checklist_items_updated_at
BEFORE UPDATE ON public.task_checklist_items
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();