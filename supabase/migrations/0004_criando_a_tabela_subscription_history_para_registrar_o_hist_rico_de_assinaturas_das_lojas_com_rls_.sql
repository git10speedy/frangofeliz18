-- Create subscription_history table
CREATE TABLE public.subscription_history (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  store_id UUID NOT NULL REFERENCES public.stores(id) ON DELETE CASCADE,
  subscription_plan public.subscription_type NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status TEXT NOT NULL DEFAULT 'active', -- e.g., 'active', 'expired', 'cancelled'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (REQUIRED)
ALTER TABLE public.subscription_history ENABLE ROW LEVEL SECURITY;

-- Policies for subscription_history
CREATE POLICY "Store managers can view their own subscription history" ON public.subscription_history
FOR SELECT TO authenticated
USING (store_id IN (SELECT profiles.store_id FROM profiles WHERE profiles.id = auth.uid()));

CREATE POLICY "Admins can manage all subscription history" ON public.subscription_history
FOR ALL TO authenticated
USING (public.has_role(auth.uid(), 'admin'::app_role));