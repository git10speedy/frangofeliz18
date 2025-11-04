-- Create the ENUM type for subscription plans if it doesn't exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'subscription_type') THEN
        CREATE TYPE public.subscription_type AS ENUM ('free', 'monthly', 'annual');
    END IF;
END $$;

-- Add subscription_plan column to stores table if it doesn't exist
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'stores' AND column_name = 'subscription_plan') THEN
        ALTER TABLE public.stores
        ADD COLUMN subscription_plan public.subscription_type DEFAULT 'free';
    END IF;
END $$;

-- Update existing stores to 'free' if subscription_plan is null (for backward compatibility)
UPDATE public.stores
SET subscription_plan = 'free'
WHERE subscription_plan IS NULL;