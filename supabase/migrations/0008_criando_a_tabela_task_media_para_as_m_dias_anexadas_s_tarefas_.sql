CREATE TABLE public.task_media (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE NOT NULL,
  file_url TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_type TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.task_media ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Store managers can view their task media" ON public.task_media
FOR SELECT TO authenticated USING (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE POLICY "Store managers can insert their task media" ON public.task_media
FOR INSERT TO authenticated WITH CHECK (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));

CREATE POLICY "Store managers can delete their task media" ON public.task_media
FOR DELETE TO authenticated USING (task_id IN (SELECT tasks.id FROM tasks WHERE tasks.store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid())));