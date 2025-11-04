-- Add is_packaging field to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_packaging BOOLEAN DEFAULT FALSE;

-- Create product_packaging_links table
CREATE TABLE IF NOT EXISTS product_packaging_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  packaging_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(packaging_id, product_id)
);

-- Add RLS policies for product_packaging_links
ALTER TABLE product_packaging_links ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view packaging links from their store"
  ON product_packaging_links FOR SELECT
  USING (store_id IN (SELECT store_id FROM profiles WHERE id = auth.uid()));

CREATE POLICY "Users can insert packaging links to their store"
  ON product_packaging_links FOR INSERT
  WITH CHECK (store_id IN (SELECT store_id FROM profiles WHERE id = auth.uid()));

CREATE POLICY "Users can update packaging links from their store"
  ON product_packaging_links FOR UPDATE
  USING (store_id IN (SELECT store_id FROM profiles WHERE id = auth.uid()));

CREATE POLICY "Users can delete packaging links from their store"
  ON product_packaging_links FOR DELETE
  USING (store_id IN (SELECT store_id FROM profiles WHERE id = auth.uid()));

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_product_packaging_links_packaging_id ON product_packaging_links(packaging_id);
CREATE INDEX IF NOT EXISTS idx_product_packaging_links_product_id ON product_packaging_links(product_id);
CREATE INDEX IF NOT EXISTS idx_product_packaging_links_store_id ON product_packaging_links(store_id);
