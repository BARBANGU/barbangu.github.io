# Bangu 2030 | Gestão de Bares — Documentação Técnica e Manual de Operação

Sistema completo de gestão dos bares do estádio: planejamento do jogo, carga, venda, caixa, devolução e fechamento — desenhado para funcionar no celular, no tablet e no computador, **inclusive sem internet**.

---

## 1. Visão geral

O Bangu 2030 é um **Progressive Web App (PWA)** de arquitetura *offline-first*: todos os dados ficam salvos no próprio aparelho e, quando a sincronização na nuvem está configurada (Supabase, plano gratuito), todos os aparelhos da operação — almoxarifado, coordenação e os três bares — compartilham os mesmos dados.

O pacote contém cinco arquivos:

| Arquivo | Função |
|---|---|
| `index.html` | O sistema completo (interface + lógica + banco local) |
| `manifest.json` | Torna o app instalável no Android e iPhone |
| `sw.js` | Service worker — faz o app abrir mesmo sem internet |
| `icon-192.png` / `icon-512.png` | Ícones do aplicativo |
| `supabase_setup.sql` | Script para criar a nuvem de sincronização |

## 2. Como colocar no ar (5 minutos)

O app precisa ser hospedado em um endereço `https` para ser instalável e sincronizar. Três opções gratuitas, da mais simples para a mais completa:

1. **Netlify Drop** (recomendado): acesse `app.netlify.com/drop`, arraste a pasta `bangu2030` inteira para a página e pronto — você recebe um endereço como `bangu2030.netlify.app`.
2. **Vercel**: crie uma conta em `vercel.com`, importe a pasta como projeto estático.
3. **GitHub Pages**: suba os arquivos num repositório e ative o Pages nas configurações.

Para **testar agora sem hospedar**, basta abrir o `index.html` no navegador — tudo funciona, exceto a instalação na tela inicial e o cache offline automático (que dependem de `https`).

### Instalando nos aparelhos da operação

No endereço hospedado: **Android (Chrome)** → menu ⋮ → "Instalar aplicativo". **iPhone (Safari)** → botão Compartilhar → "Adicionar à Tela de Início". O app abre em tela cheia, com ícone próprio, como um aplicativo nativo.

## 3. Acesso e perfis

O login é por **PIN de 4 dígitos** com botões grandes — pensado para o corre do dia de jogo. Usuários que já vêm cadastrados (troque os PINs em **Usuários** antes do primeiro jogo real):

| Usuário | Perfil | PIN inicial | O que pode fazer |
|---|---|---|---|
| Administrador | Administrador | `1234` | Tudo: usuários, produtos, preços, relatórios, estoque, fechamento |
| Almoxarifado | Almoxarifado | `1111` | Compras, recebimento, romaneio de carga, reposições, devoluções, estoque |
| Coordenador A&B | Coordenador | `2222` | Vendas em tempo real, solicitar reposição, estoque dos bares, fechar operação |
| Caixa Social | Caixa (Bar Social) | `3333` | Vender, receber, consultar preços — tela travada no seu bar |
| Caixa Bangu | Caixa (Bar Bangu) | `4444` | Idem |
| Caixa Visitante | Caixa (Bar Visitante) | `5555` | Idem |

Cada caixa enxerga apenas a tela do seu bar (Social, Bangu ou Visitante), com o cardápio e o estoque daquele ponto.

## 4. O fluxo do dia de jogo

**Antes do jogo** — o administrador cadastra a partida em **Jogos** (adversário, campeonato, data, horário e público previsto por setor). O botão **🧠 Sugestão de compra** calcula quanto comprar de cada produto: com histórico, usa o consumo médio por torcedor dos jogos anteriores; sem histórico, usa uma tabela padrão por categoria — sempre com +10% de segurança. O almoxarifado lança as **Compras** (fornecedor, NF, itens), e o estoque central sobe automaticamente.

**Abertura** — o coordenador toca **▶ Iniciar operação**. O almoxarifado gera o **Romaneio** de cada bar (quantidades pré-calculadas pela proporção de público do setor), assina digitalmente e envia. No bar, o responsável confere, ajusta o que recebeu de fato e assina o recebimento — divergências voltam sozinhas para o estoque central. Cada caixa abre seu **Caixa** informando o troco inicial.

**Durante o jogo** — os caixas vendem na tela **Vender**: toque no produto, escolha PIX, dinheiro ou cartão e finalize; o estoque do bar baixa na hora. Faltou mercadoria? O bar pede **Reposição**, o almoxarifado aprova, separa e a entrega é registrada com assinatura de quem entregou e de quem recebeu. O coordenador acompanha tudo ao vivo no **Dashboard**: receita, lucro, ticket médio, venda por minuto, venda por bar, CMV, margem e produtos parados.

**Encerramento** — cada caixa faz a **sangria** se necessário e fecha o caixa contando o dinheiro da gaveta; o sistema aponta a diferença automaticamente. Cada bar registra a **Devolução** (o que volta, o que se perdeu, o que danificou e por quê), assina, e o estoque central é atualizado. Por fim o coordenador **encerra a operação** com assinatura — e o relatório de fechamento fica disponível em PDF.

## 5. Módulos (mapa completo)

1. **Produtos** — código, código de barras, nome, categoria (Água, Refrigerante, Guaracamp, Cerveja, Salgados, Pipoca, Amendoim, Batata, Torresmo, Bolo consignado, Outros), fornecedor, custo, preço, margem calculada, estoque mínimo/atual, foto, unidade, ativo/inativo.
2. **Compras** — fornecedor, data, NF, itens, valor, responsável; atualiza estoque e custo automaticamente.
3. **Planejamento do jogo** — adversário, campeonato, data/hora, público por setor, sugestão de compra por histórico.
4. **Romaneio de carga** — por bar, com enviado × recebido, data/hora, responsáveis e assinaturas.
5. **Reposição** — solicitação → aprovação → entrega, com horário, quem entregou/recebeu e assinaturas.
6. **Vendas (PDV)** — botões grandes, busca, código de barras, voz; PIX/dinheiro/cartão; baixa automática de estoque.
7. **Caixa** — um por bar: troco inicial, PIX, cartão, dinheiro, sangrias, total e diferença na conferência.
8. **Devolução** — devolvido, perdido, danificado, motivo e assinatura; estoque central atualizado.
9. **Dashboard** — receita, lucro, mais vendidos, parados, ticket médio, venda/minuto, venda por bar, consumo por torcedor, CMV, margem, perdas.
10. **Relatórios** — PDF (via imprimir/salvar) de romaneio, caixa, devolução, fechamento, inventário e histórico de jogos; exportação Excel (CSV) de estoque, vendas, sugestão de compra e auditoria.
11. **Indicadores** — receita por jogo/campeonato/setor, margem, CMV, produtos mais lucrativos, maior desperdício, ticket médio, consumo por pessoa, lucro líquido.
12. **Assinatura digital** — obrigatória em recebimento, reposição, devolução e fechamentos; fica gravada no histórico e sai impressa nos PDFs.

Extras: modo escuro, busca por voz (pt-BR), leitor de código de barras (qualquer leitor USB/Bluetooth que digite o código funciona — é só bipar com o campo de busca ativo), backup completo em um arquivo, trilha de auditoria com quem fez, quando e o quê.

## 6. Sincronização na nuvem (vários aparelhos juntos)

1. Crie uma conta gratuita em **supabase.com** e um projeto (ex.: `bangu2030`).
2. No projeto, abra **SQL Editor**, cole o conteúdo de `supabase_setup.sql` e clique **Run**.
3. Em **Settings → API**, copie a **Project URL** e a chave **anon public**.
4. No app, entre como Administrador → **Ajustes → Sincronização na nuvem**, cole os dois valores, marque **Sincronizar automaticamente** e salve — **repita em cada aparelho** da operação.

A partir daí, cada venda, romaneio e reposição sobe para a nuvem e desce para os outros aparelhos (alguns segundos após cada ação, e sempre que tocar em ☁️). Sem internet no estádio? Nenhum problema: tudo continua funcionando localmente e sincroniza sozinho quando a conexão voltar.

**Como funciona por dentro:** cada registro (venda, produto, jogo…) vira uma linha na tabela `bangu_registros` com carimbo de data/hora. Na mesclagem vale a versão mais recente (*last-write-wins*). Exclusões são propagadas por uma lista de tombstones (`excluidos`).

**Boas práticas para evitar conflitos:** cada bar vende apenas no seu próprio aparelho (é o desenho natural do sistema); cadastro de produtos e preços deve ser feito num aparelho só (o do administrador); sincronize todos os aparelhos antes de abrir e depois de encerrar a operação.

## 7. Arquitetura técnica

**Stack:** HTML5 + CSS3 + JavaScript puro (zero dependências externas — nada quebra sem internet), arquivo único, ~120 KB. Service worker com cache-first para abertura offline. Persistência local em `localStorage` (com fallback em memória). Sincronização por REST (PostgREST/Supabase) com upsert em lote.

**Modelo de dados (coleções):** `usuarios`, `produtos`, `compras`, `jogos`, `romaneios`, `reposicoes`, `vendas`, `caixas`, `devolucoes`, `ajustes`, `auditoria`, `excluidos`. Todos os registros carregam `id` único e `updatedAt`.

**Regra de ouro do estoque:** o estoque **central** é um saldo mantido nos produtos (entra por compra e devolução, sai por romaneio e reposição). O estoque de **cada bar é derivado** — calculado sempre a partir dos eventos (romaneios recebidos + reposições entregues − vendas − devoluções). Isso elimina divergência de saldo entre aparelhos: o número é sempre a soma dos fatos registrados.

**Auditoria:** toda ação relevante grava quem, quando e o quê; as assinaturas ficam como imagem (PNG base64) dentro do próprio registro e saem nos PDFs.

**Segurança:** PINs de acesso por perfil; chave anon do Supabase restrita à equipe; RLS habilitado na tabela (política aberta para uso interno — o script traz a instrução para endurecer com Supabase Auth quando desejado).

## 8. Evolução futura

O código é modular (cada tela é um objeto em `TELAS`, cada domínio tem suas funções) e o modelo por coleções versionadas foi desenhado para crescer. Caminhos naturais: bilheteria, loja oficial, estacionamento e eventos entram como novas coleções e telas sem tocar no núcleo; a camada `Sync` já suporta novas coleções apenas adicionando o nome na lista `COLECOES`; múltiplas contas/estádios saem de um campo `org` nas linhas da nuvem; e a migração futura para um backend dedicado (Node/Postgres) pode reaproveitar o modelo de eventos como está.

## 9. Suporte rápido (FAQ)

**Esqueci de fechar um caixa e o jogo encerrou** — o caixa continua acessível na tela Caixa até ser fechado. **Errei uma contagem de estoque** — use Estoque → Ajustar (exige motivo, fica na auditoria). **Troquei de celular** — Ajustes → Exportar backup no antigo, Restaurar no novo (ou apenas sincronize pela nuvem). **O PDF não gera** — o relatório usa a impressão do navegador: escolha "Salvar como PDF" na janela que abre. **Quero apagar tudo e começar do zero** — limpe os dados do site nas configurações do navegador (e a tabela no Supabase, se sincronizado).
