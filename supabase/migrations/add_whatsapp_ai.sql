-- Add WhatsApp AI fields to stores table
ALTER TABLE stores ADD COLUMN IF NOT EXISTS whatsapp_ai_enabled BOOLEAN DEFAULT FALSE;
ALTER TABLE stores ADD COLUMN IF NOT EXISTS whatsapp_ai_api_key TEXT;

-- Add comment to columns
COMMENT ON COLUMN stores.whatsapp_ai_enabled IS 'Enable WhatsApp AI assistant for the store';
COMMENT ON COLUMN stores.whatsapp_ai_api_key IS 'API key for WhatsApp AI integration (placeholder for future implementation)';
