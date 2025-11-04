# Como Testar as Funcionalidades do Monitor

## Data: 01/11/2024

---

## 🧪 Guia de Testes - Monitor

### Pré-requisitos

1. **Ter uma loja cadastrada** com um slug (ex: `minha-loja`)
2. **Configurar banners** (opcional, para testar slideshow)
3. **Ter produtos cadastrados** para criar pedidos de teste

---

## 📋 Testes a Realizar

### 1. Teste da Notificação Sonora 🔊

#### Passo a Passo:

1. **Acessar o Monitor:**
   ```
   http://localhost:3002/monitor/sua-loja-slug
   ```

2. **Verificar o botão de som:**
   - Procure no canto superior direito da tela
   - Deve aparecer: "Ativar Som" ou "Som Ativo"
   - Ícone: 🔇 (VolumeX) ou 🔊 (Volume2)

3. **Ativar o Som:**
   - Clique no botão "Ativar Som"
   - Um som de teste deve tocar IMEDIATAMENTE
   - O botão muda para "Som Ativo" (verde)
   - Estado é salvo no localStorage

4. **Criar um Pedido Teste:**
   - Abra outra aba/janela
   - Vá para: `http://localhost:3002/loja/sua-loja-slug`
   - Ou: `http://localhost:3002/totem/sua-loja-slug`
   - Faça um pedido completo

5. **Verificar Notificação:**
   - Volte para a aba do Monitor
   - O som deve tocar automaticamente
   - O pedido aparece na coluna correspondente ao status

#### ✅ Resultado Esperado:
- ✅ Botão visível e responsivo
- ✅ Som de teste toca ao ativar
- ✅ Som toca automaticamente em novos pedidos
- ✅ Estado persiste ao recarregar página

---

### 2. Teste do Badge de Foguinho 🔥

#### Passo a Passo:

1. **Criar Pedido de Teste:**
   - Com o Monitor aberto em uma aba
   - Em outra aba, crie um pedido via:
     - Loja Online (`/loja/sua-loja-slug`)
     - Totem (`/totem/sua-loja-slug`)
     - WhatsApp (se configurado)

2. **Observar o Monitor:**
   - O pedido aparece instantaneamente
   - Badge 🔥 deve aparecer no canto superior direito do card
   - Emoji grande (text-4xl)
   - Com sombra vermelha brilhante
   - Animações: bounce + pulse

3. **Aguardar 10 Segundos:**
   - O badge desaparece automaticamente
   - O pedido permanece na coluna

#### ✅ Resultado Esperado:
- ✅ Badge 🔥 aparece imediatamente
- ✅ Grande e visível (text-4xl)
- ✅ Animações funcionando (bounce + pulse)
- ✅ Sombra vermelha destacada
- ✅ Desaparece após 10 segundos

---

### 3. Teste do Slideshow em Tela Cheia 🎬

#### Pré-requisito:
- Ter banners cadastrados em `/marketing`

#### Passo a Passo:

1. **Configurar Banners:**
   - Vá para `/marketing`
   - Adicione pelo menos 2-3 banners

2. **Configurar Timeout (Opcional):**
   - No banco de dados, tabela `stores`
   - Ajuste `monitor_idle_timeout_seconds` (padrão: 30)
   - Para teste rápido, coloque 10 segundos

3. **Testar Modo Slideshow:**
   - Acesse o Monitor
   - **Aguarde** sem criar pedidos
   - Após o timeout, o slideshow começa
   - Ocupa toda a tela
   - Background preto
   - Banners em loop automático

4. **Testar Retorno Automático:**
   - Com slideshow ativo
   - Crie um novo pedido
   - Monitor volta automaticamente para tela de pedidos

#### ✅ Resultado Esperado:
- ✅ Slideshow em tela cheia após timeout
- ✅ Background preto
- ✅ Imagens em object-cover (preenche tela)
- ✅ Loop automático
- ✅ Volta para pedidos ao receber novo pedido

---

### 4. Teste de Notificação em Tempo Real 🔔

#### Passo a Passo:

1. **Abrir Monitor em uma Aba:**
   ```
   http://localhost:3002/monitor/sua-loja-slug
   ```

2. **Abrir OrderPanel em Outra Aba:**
   ```
   http://localhost:3002/painel
   ```

3. **Criar Pedido via Loja:**
   ```
   http://localhost:3002/loja/sua-loja-slug
   ```

4. **Observar Sincronização:**
   - Novo pedido aparece instantaneamente em ambas as abas
   - Som toca no Monitor
   - Badge 🔥 aparece
   - Sem necessidade de refresh

5. **Testar Mudança de Status:**
   - No OrderPanel, mude o status de um pedido
   - Monitor atualiza instantaneamente
   - Pedido move para coluna correta

#### ✅ Resultado Esperado:
- ✅ Sincronização em tempo real
- ✅ Sem delay perceptível
- ✅ Notificações funcionando
- ✅ Atualização automática de status

---

## 🎯 Checklist Geral

### Funcionalidades Implementadas:
- ✅ Notificação sonora no Monitor
- ✅ Badge de foguinho 🔥 no Monitor
- ✅ Slideshow em tela cheia
- ✅ Botão de controle de som
- ✅ Notificações em tempo real
- ✅ Atualização automática de pedidos
- ✅ Timer de ociosidade configurável
- ✅ Transição automática slideshow ↔ pedidos

### Origens que Disparam Notificações:
- ✅ `whatsapp`
- ✅ `totem`
- ✅ `loja_online`
- ❌ `pdv` (não dispara, é interno)

---

## 🐛 Solução de Problemas

### Som Não Toca:
1. Verificar se o botão está em "Som Ativo"
2. Verificar volume do navegador/sistema
3. Alguns navegadores bloqueiam autoplay - clicar em "Ativar Som" resolve
4. Verificar console do navegador para erros
5. Arquivo `/public/notification.mp3` deve existir

### Badge Não Aparece:
1. Verificar origem do pedido (deve ser whatsapp, totem ou loja_online)
2. Verificar console para array `newOrderIds`
3. Badge desaparece após 10 segundos (comportamento esperado)

### Slideshow Não Ativa:
1. Verificar se há banners cadastrados em `/marketing`
2. Verificar timeout configurado (padrão 30s)
3. Certificar que não há pedidos ativos no fluxo
4. Verificar console para `showSlideshow: true`

### Monitor Não Atualiza:
1. Verificar conexão Realtime do Supabase
2. Verificar console para eventos 'postgres_changes'
3. Verificar filtro de `store_id` correto
4. Recarregar página e verificar novamente

---

## 📞 Informações Técnicas

### Arquivos Principais:
- `/src/pages/Monitor.tsx` - Página principal
- `/src/hooks/useSoundNotification.tsx` - Hook de som
- `/public/notification.mp3` - Arquivo de áudio

### Configurações no Banco (tabela `stores`):
- `monitor_slideshow_delay` - Tempo entre slides (ms)
- `monitor_idle_timeout_seconds` - Timeout para slideshow (s)
- `monitor_fullscreen_slideshow` - Flag (atualmente não usada)

### LocalStorage:
- `sound_notifications_enabled` - Estado do som (true/false)

---

## ✅ Conclusão

Todas as funcionalidades estão implementadas e prontas para teste!
Se seguir este guia, você poderá verificar que:
- 🔊 Som funciona perfeitamente
- 🔥 Badge aparece e desaparece corretamente
- 🎬 Slideshow em tela cheia funciona
- 🔔 Notificações em tempo real funcionam
