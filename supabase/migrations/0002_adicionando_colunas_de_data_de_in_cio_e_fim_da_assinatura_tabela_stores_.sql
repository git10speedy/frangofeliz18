-- Add subscription_start_date column to stores table if it doesn't exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stores' AND column_name = 'subscription_start_date') THEN
        ALTER TABLE public.stores
        ADD COLUMN subscription_start_date DATE;
    END IF;
END $$;

-- Add subscription_end_date column to stores table if it doesn't exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stores' AND column_name = 'subscription_end_date') THEN
        ALTER TABLE public.stores
        ADD COLUMN subscription_end_date DATE;
    END IF;
END $$;