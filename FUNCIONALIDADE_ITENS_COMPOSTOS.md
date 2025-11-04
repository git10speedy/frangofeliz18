# 📦 Funcionalidade: Itens Compostos

## 🎯 Objetivo

Permitir que variações de produtos sejam derivadas de outros produtos (matéria-prima), com controle automático de estoque. Exemplo: um Frango Assado Inteiro pode gerar 2 Meios Frangos.

---

## 🚀 Como Usar

### 1️⃣ Cadastrar um Produto com Variações

1. Acesse **Produtos**
2. Adicione um produto marcando **"Possui Variações?"** = SIM
3. Exemplo: Produto = "Frango Assado Recheado"

### 2️⃣ Criar uma Variação como Item Composto

1. Clique em **Gerenciar Variações** no produto criado
2. Preencha o nome da variação: "Meio Frango Assado Recheado"
3. Marque **"Este é um Item Composto?"** = SIM
4. Configure:
   - **Matéria-Prima**: Selecione um produto OU uma variação de outro produto
     - **Produtos** aparecem com ícone 📦
     - **Variações** aparecem com ícone 🔸 e mostram: Nome do Produto - Nome da Variação
   - **Rendimento**: Digite 2 (quantas unidades gera)
5. Salve a variação

### Exemplo com Variações:

**Produto: Farofa**
- Variação 1: Farofa de Bacon
  - É composto: SIM
  - Matéria-prima: 🔸 Bacon - Bacon Picado (variação)
  - Rendimento: 3
  
- Variação 2: Farofa de Pão
  - É composto: SIM
  - Matéria-prima: 📦 Pão Amanhecido (produto)
  - Rendimento: 5

---

## 📋 Como Funciona

### Ao Vender um Item Composto:

**Exemplo:** Cliente compra 1 "Meio Frango Assado Recheado"

1. ✅ Sistema verifica que é um item composto
2. ✅ Consome 0.5 unidades da matéria-prima "Frango Assado Recheado" (arredonda para 1)
3. ✅ Gera 2 unidades de "Meio Frango Assado Recheado" no estoque
4. ✅ Subtrai 1 unidade vendida
5. ✅ Estoque final da variação = 1 unidade disponível
6. ✅ Registra a transação para possível reversão

### Cálculo de Consumo de Matéria-Prima:

```
Matéria-prima consumida = ARREDONDAR_PARA_CIMA(Quantidade vendida / Rendimento)
```

**Exemplos:**
- Venda: 1 unidade | Rendimento: 2 → Consome 1 matéria-prima
- Venda: 3 unidades | Rendimento: 2 → Consome 2 matérias-primas
- Venda: 2 unidades | Rendimento: 4 → Consome 1 matéria-prima

### Cálculo de Unidades Geradas:

```
Unidades geradas = Matéria-prima consumida × Rendimento
Estoque final = Estoque anterior + Unidades geradas - Quantidade vendida
```

---

## 🔄 Reversão em Cancelamentos (Futuro)

Quando um pedido com item composto for cancelado, o sistema:

1. Busca a transação registrada em `composite_item_transactions`
2. Restaura o estoque da matéria-prima
3. Ajusta o estoque da variação
4. Marca a transação como revertida

---

## 🎨 Interface

### Card de Item Composto

- **Switch** para ativar/desativar
- **Dropdown** para selecionar matéria-prima (mostra produtos sem variação)
- **Campo numérico** para definir o rendimento
- **Exemplo visual** explicando o funcionamento
- **Badge "Item Composto"** na listagem de variações
- **Informações** sobre matéria-prima e rendimento

### Validações

- ✅ Matéria-prima é obrigatória quando marcado como composto
- ✅ Rendimento mínimo = 1
- ✅ Não permite selecionar o próprio produto como matéria-prima
- ✅ Estoque inicial desabilitado (gerado automaticamente)

---

## 💾 Estrutura do Banco de Dados

### Tabela: `product_variations`

Novos campos:
- `is_composite` (BOOLEAN) - Se é um item composto
- `raw_material_product_id` (UUID) - ID da matéria-prima
- `yield_quantity` (INTEGER) - Quantidade gerada por unidade

### Tabela: `composite_item_transactions`

Registra cada venda de item composto:
- `order_id` - ID do pedido
- `order_item_id` - ID do item do pedido
- `variation_id` - ID da variação vendida
- `raw_material_product_id` - ID da matéria-prima consumida
- `raw_material_consumed` - Quantidade consumida
- `variations_generated` - Quantidade gerada
- `reversed_at` - Data da reversão (NULL se não revertido)

---

## 📊 Exemplo Completo

### Cadastro:

```
Produto: Frango Assado Recheado
├─ Estoque: 10 unidades
├─ Preço: R$ 35,00
└─ Variação: Meio Frango Assado Recheado
   ├─ Item Composto: SIM
   ├─ Matéria-prima: Frango Assado Recheado
   ├─ Rendimento: 2
   ├─ Ajuste de preço: R$ -15,00
   └─ Estoque: 0 (será gerado na venda)
```

### Venda no PDV:

```
Cliente compra: 1x Meio Frango Assado Recheado (R$ 20,00)

Processamento automático:
1. Consome 1 Frango Assado Recheado
   Estoque antes: 10 → Estoque depois: 9

2. Gera 2 Meios Frangos
   Estoque antes: 0 → Estoque depois: 2

3. Vende 1 Meio Frango
   Estoque depois: 1

Resultado:
✅ Frango Assado Recheado: 9 unidades
✅ Meio Frango Assado Recheado: 1 unidade
✅ Cliente recebeu 1 Meio Frango
✅ Transação registrada para possível reversão
```

---

## ⚠️ Observações Importantes

1. **Não venda diretamente matérias-primas usadas em itens compostos** se quiser manter o controle preciso
2. **Planeje o rendimento cuidadosamente** - uma vez vendido, a transação é calculada com base nele
3. **Estoque de itens compostos** pode ficar com saldo mesmo após vendas (devido ao rendimento)
4. **Cancelamentos** ainda precisam ser implementados manualmente por enquanto

---

## 🔧 Ativação no Banco

Execute o SQL em `EXECUTAR_NO_SUPABASE.sql` no seu painel do Supabase para ativar esta funcionalidade.

---

## ✅ Critérios Atendidos

- ✅ Produto composto pode ser vendido mesmo com estoque = 0
- ✅ Matéria-prima é reduzida ao final da venda confirmada
- ✅ Estrutura preparada para reversão em cancelamentos
- ✅ UI amigável com explicações e exemplos
- ✅ Interface e lógica integradas com Supabase
- ✅ Comportamento de estoque consistente
- ✅ Fluxo de venda robusto

---

## 📝 Próximos Passos

1. Implementar reversão automática em cancelamentos de pedidos
2. Adicionar relatório de itens compostos vendidos
3. Dashboard com alertas de matéria-prima baixa
4. Histórico de transações de itens compostos
