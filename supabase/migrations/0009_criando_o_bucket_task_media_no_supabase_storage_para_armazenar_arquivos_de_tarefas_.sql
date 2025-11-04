INSERT INTO storage.buckets (id, name, public)
VALUES ('task-media', 'task-media', TRUE)
ON CONFLICT (id) DO NOTHING;

-- Adicionando políticas de segurança para o bucket 'task-media'
-- Permite que usuários autenticados façam upload de arquivos
CREATE POLICY "Allow authenticated uploads" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'task-media');

-- Permite que usuários autenticados visualizem arquivos
CREATE POLICY "Allow authenticated reads" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'task-media');

-- Permite que usuários autenticados excluam seus próprios arquivos (se necessário, pode ser mais restritivo)
CREATE POLICY "Allow authenticated deletes" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'task-media');