-- =====================================================
-- SQL para adicionar suporte a Variações como Matéria-Prima
-- Execute APENAS este arquivo se você já executou o EXECUTAR_NO_SUPABASE.sql antes
-- =====================================================

-- Adicionar colunas que podem estar faltando na tabela products
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_perishable BOOLEAN DEFAULT FALSE;
ALTER TABLE products ADD COLUMN IF NOT EXISTS cost_price DECIMAL(10,2) DEFAULT 0.00;

-- Adicionar campo para variações poderem usar outras variações como matéria-prima
ALTER TABLE product_variations ADD COLUMN IF NOT EXISTS raw_material_variation_id UUID REFERENCES product_variations(id) ON DELETE SET NULL;

-- Adicionar comentários
COMMENT ON COLUMN products.is_perishable IS 'Indicates if the product is perishable';
COMMENT ON COLUMN products.cost_price IS 'Cost price of the product for profit calculation';
COMMENT ON COLUMN product_variations.raw_material_variation_id IS 'The variation ID that serves as raw material (for variations as raw material)';

-- =====================================================
-- Pronto! Agora você pode usar variações como matéria-prima
-- =====================================================
-- 
-- Exemplo de uso:
-- 
-- Produto: Farofa
--   Variação 1: Farofa de Bacon
--     - Item Composto: SIM
--     - Matéria-prima: Bacon - Bacon Picado (variação)
--     - Rendimento: 3
--   
--   Variação 2: Farofa de Pão
--     - Item Composto: SIM
--     - Matéria-prima: Pão Amanhecido (produto)
--     - Rendimento: 5
--
-- =====================================================
