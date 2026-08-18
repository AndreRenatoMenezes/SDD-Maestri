# Descoberta

A conversa é o produto; escrever a spec é a parte fácil. Mas descoberta demais cansa o usuário tanto quanto descoberta de menos estraga o contrato.

**Teto: 3 perguntas curtas.** Uma por vez, com opções concretas. Depois um recap de uma linha e siga.

Se o usuário já respondeu algo na mensagem original, **não repergunte**. O objetivo é fechar lacuna real, não preencher formulário.

## Quando pular a descoberta inteira

- O pedido já traz categoria, escopo, critério de aceite e stack.
- Feature pequena que cabe numa WP e num executor.
- O usuário está no meio de uma iteração de algo que esta skill já produziu.

Escolha barata e reversível que sobrou: **decida você**, registre em `decisoes.md`, mencione no recap. O usuário corrige se quiser.

## Rodada 1 — o resultado

O que muda no mundo quando isso estiver pronto? Puxe pelo usuário final, não pela implementação.

Objetivo da resposta: conseguir escrever "destino" e "critério de aceite verificável". Se você não consegue imaginar o teste que prova que acabou, a resposta não serve ainda.

## Rodada 2 — a fronteira

O que está **fora**? A pergunta que mais economiza retrabalho.

Ofereça 3–4 recortes concretos ("só o backend agora, tela depois" / "inclui migração de dados existentes" / "inclui tela de admin"), com "Outro" sempre disponível.

## Rodada 3 — o que é caro de errar

Só faça se sobrou ambiguidade consequente. Candidatos: regra de negócio faltando, contrato de dado com sistema externo, escolha de provedor pago, tratamento de dado pessoal, migração destrutiva.

Se não sobrou nada disso, não pergunte. Não invente uma terceira pergunta só porque o teto permite três.

## Recap

Uma frase, antes de escrever a spec:

> "Beleza — login via Google, só backend, sem tela de admin, reaproveitando a tabela `users`, migração não destrutiva. Escrevendo a spec."

## Skills de descoberta

Se o workspace tiver instalada alguma skill de descoberta, prefira, nesta ordem:

1. `wayfinder` — trabalho maior que uma sessão ou com névoa de decisão não resolvida
2. `grill-me` — ambiguidade consequente, uma pergunta por vez
3. `grill-with-docs` — quando documentos fornecidos governam a decisão
4. `to-questionnaire` — várias decisões independentes que podem ser respondidas de uma vez

Nenhuma instalada: use as três rodadas acima.

## Fronteira de autoridade

| Você decide e registra | Você pergunta |
|---|---|
| nome de variável, estrutura de pasta, ordem das WPs | mudança de escopo ou de critério de aceite |
| biblioteca já usada no projeto | troca de stack, banco, provedor ou serviço pago |
| formato de log, convenção de teste | regra de negócio faltando |
| como particionar em ondas | segurança, credencial, dado pessoal, privacidade, regulatório |
| codinome e preset de cada executor | migração destrutiva ou mudança de schema em produção |
| layout do painel | trade-off real de prazo, custo ou qualidade |
| | abrir PR, mergear, deployar, publicar, comunicar externamente |

Regra geral: **custo de reverter**. Barato de reverter é seu. Caro de reverter é do usuário.
