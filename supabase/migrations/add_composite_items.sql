-- Add composite item fields to product_variations table
ALTER TABLE product_variations ADD COLUMN IF NOT EXISTS is_composite BOOLEAN DEFAULT FALSE;
ALTER TABLE product_variations ADD COLUMN IF NOT EXISTS raw_material_product_id UUID REFERENCES products(id) ON DELETE SET NULL;
ALTER TABLE product_variations ADD COLUMN IF NOT EXISTS raw_material_variation_id UUID REFERENCES product_variations(id) ON DELETE SET NULL;
ALTER TABLE product_variations ADD COLUMN IF NOT EXISTS yield_quantity INTEGER DEFAULT 1;

-- Add comments for documentation
COMMENT ON COLUMN product_variations.is_composite IS 'Indicates if this variation is a composite item that derives from a raw material';
COMMENT ON COLUMN product_variations.raw_material_product_id IS 'The product ID that serves as raw material (for simple products)';
COMMENT ON COLUMN product_variations.raw_material_variation_id IS 'The variation ID that serves as raw material (for variations)';
COMMENT ON COLUMN product_variations.yield_quantity IS 'How many units of this variation are produced from 1 unit of raw material';

-- Create table to track composite item transactions for reversal on cancellation
CREATE TABLE IF NOT EXISTS composite_item_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  order_item_id UUID NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
  variation_id UUID NOT NULL REFERENCES product_variations(id) ON DELETE CASCADE,
  raw_material_product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  raw_material_consumed INTEGER NOT NULL,
  variations_generated INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reversed_at TIMESTAMP WITH TIME ZONE
);

-- Add RLS policies
ALTER TABLE composite_item_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view composite transactions from their orders"
  ON composite_item_transactions FOR SELECT
  USING (order_id IN (
    SELECT id FROM orders WHERE store_id IN (
      SELECT store_id FROM profiles WHERE id = auth.uid()
    )
  ));

CREATE POLICY "Users can insert composite transactions for their orders"
  ON composite_item_transactions FOR INSERT
  WITH CHECK (order_id IN (
    SELECT id FROM orders WHERE store_id IN (
      SELECT store_id FROM profiles WHERE id = auth.uid()
    )
  ));

CREATE POLICY "Users can update composite transactions from their orders"
  ON composite_item_transactions FOR UPDATE
  USING (order_id IN (
    SELECT id FROM orders WHERE store_id IN (
      SELECT store_id FROM profiles WHERE id = auth.uid()
    )
  ));

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_composite_item_transactions_order_id ON composite_item_transactions(order_id);
CREATE INDEX IF NOT EXISTS idx_composite_item_transactions_variation_id ON composite_item_transactions(variation_id);
CREATE INDEX IF NOT EXISTS idx_composite_item_transactions_raw_material ON composite_item_transactions(raw_material_product_id);
CREATE INDEX IF NOT EXISTS idx_product_variations_raw_material ON product_variations(raw_material_product_id) WHERE is_composite = true;
