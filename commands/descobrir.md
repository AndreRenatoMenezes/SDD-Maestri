---
description: Lê o IDEIAS.md do projeto e começa a descoberta — o Arquiteto debate os pontos em aberto, pesquisa soluções open source, escreve specs com fluxo de uso e atualiza IDEIAS e ROADMAP
argument-hint: "[números das ideias, ex.: 2 5]"
---

Descoberta de backlog da skill sdd-maestri. `<skill>` abaixo é `${CLAUDE_PLUGIN_ROOT}/skills/sdd-maestri`. Ideias pedidas: `$ARGUMENTS` (vazio = todas as novas).

1. **Backlog.** Em `.claude/specs/` do checkout do Ground — o diretório do workspace, nunca o de um andar —, faltando `IDEIAS.md` ou `ROADMAP.md`, copie de `<skill>/modelos/`. Só crie: depois disso, quem escreve neles é o usuário e o Arquiteto.

2. **Nada para descobrir?** Sem item novo no `IDEIAS.md` (item sem `⟶`) e sem número pedido: diga ao usuário o caminho do arquivo, que é para anotar uma ideia por item, numerada, do jeito que vier, e rodar `/sdd-maestri:descobrir` de novo. Pare.

3. **Quem descobre.**

   - **Este terminal é o Maestro** (`maestri list` responde sem "not the Maestro"): Arquiteto já conectado e ocioso (`maestri check`), delegue a ele. Senão, recrute um no Ground pelo `<skill>/references/recrutamento.md` — role `SDD Arquiteto`, preset mais capaz, sugerido e confirmado numa pergunta; faltou o role, rode `/sdd-maestri:papeis` antes. Delegue com timeout curto:

     > "Descoberta de backlog. Siga `<skill>/references/backlog.md`. Backlog em `<Ground>/.claude/specs/`. Ideias: <números, ou todas as novas>. Ao terminar: `maestri ask "<seu nome>" "Backlog: <recap>"`"

     Passe a bola: diga ao usuário o nome exato do terminal do Arquiteto — a conversa é lá. Quando o recap chegar, repasse em poucas linhas. Não abra feature nem recrute executor: descoberta de backlog não é feature.

   - **Qualquer outro terminal** (sem Maestri, ou não é o Maestro): você é o Arquiteto desta descoberta. Leia `<skill>/agents/arquiteto.md`, `<skill>/references/descoberta.md` e `<skill>/references/backlog.md` — o que já está no seu role, não releia — e siga, conversando com o usuário aqui mesmo. Sem Maestro, ignore handoff e *ask back*.
