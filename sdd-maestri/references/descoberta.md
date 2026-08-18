# Descoberta

Reference do **Arquiteto**. A conversa acontece no terminal dele, com o usuário direto — o Maestro não faz proxy de pergunta.

A conversa é o produto; escrever a spec é a parte fácil. Mas descoberta demais cansa o usuário tanto quanto descoberta de menos estraga o contrato.

**Teto: 3 perguntas curtas.** Uma por vez, com opções concretas. Depois um recap de uma linha e siga.

Se o usuário já respondeu algo na mensagem original, **não repergunte**. O objetivo é fechar lacuna real, não preencher formulário.

## Quando pular a descoberta inteira

- O pedido já traz categoria, escopo, critério de aceite e stack.
- O usuário está no meio de uma iteração de algo que esta skill já produziu.

Nesses casos vá direto investigar o workspace e escrever. Escolha barata e reversível que sobrou: **decida você**, registre em `decisoes.md`, mencione no recap. O usuário corrige se quiser.

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

Regra geral: **custo de reverter**. Barato é seu, caro é do usuário.

Você decide e registra em `decisoes.md`: nome de variável e de campo interno, estrutura de pasta, biblioteca já usada no projeto, formato de log, convenção de teste, ordem de construção no `plan.md`.

Você pergunta: mudança de escopo ou de critério de aceite; regra de negócio faltando; troca de stack, banco, provedor ou serviço pago; migração destrutiva ou mudança de schema em produção; segurança, credencial, dado pessoal, privacidade, regulatório.

Não é seu nem do usuário — é do Maestro: partição em WPs e ondas, codinome dos executores, quem possui qual path, escolha de preset. Você sugere fronteiras de arquivo no handoff; quem decide a partição é ele.
