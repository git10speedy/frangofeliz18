-- Function to handle subscription status changes
CREATE OR REPLACE FUNCTION public.handle_subscription_status_change()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'pg_temp'
AS $$
BEGIN
    -- If the new plan is 'free', clear start and end dates
    IF NEW.subscription_plan = 'free' THEN
        NEW.subscription_start_date := NULL;
        NEW.subscription_end_date := NULL;
    -- If a paid plan is set, but the end date is in the past, revert to 'free'
    ELSIF NEW.subscription_plan IS NOT NULL AND NEW.subscription_plan != 'free' AND NEW.subscription_end_date IS NOT NULL AND NEW.subscription_end_date < CURRENT_DATE THEN
        NEW.subscription_plan := 'free';
        NEW.subscription_start_date := NULL;
        NEW.subscription_end_date := NULL;
        RAISE WARNING 'Subscription for store % (ID: %) automatically reverted to FREE because the end date % is in the past.', NEW.display_name, NEW.id, NEW.subscription_end_date;
    END IF;

    RETURN NEW;
END;
$$;

-- Trigger to call the function before updating a store
DROP TRIGGER IF EXISTS on_stores_subscription_update ON public.stores;
CREATE TRIGGER on_stores_subscription_update
BEFORE UPDATE ON public.stores
FOR EACH ROW EXECUTE FUNCTION public.handle_subscription_status_change();