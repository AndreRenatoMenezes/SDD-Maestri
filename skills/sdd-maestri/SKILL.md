---
name: sdd-maestri
description: Orquestra um time de agentes no Maestri com spec em markdown como contrato — Arquiteto faz a descoberta e escreve spec/plan, Maestro abre a feature no seu checkout ou num andar isolado, particiona por dono de arquivo, recruta executores e mantém painel e status do andar. Use quando, num terminal Maestro, o usuário pedir para montar um time, orquestrar vários agentes numa feature, ou mencionar SDD/spec-driven com Maestri, partitura de time, recrutar Arquiteto/Engineer/Reviewer ou git-master. Não use para operação avulsa de canvas (nota, portal, rotina, um ask) — isso é das skills maestri-*.
---

> **Você recebeu um role de executor (Arquiteto, Engineer, Reviewer, Git Master)? Pare de ler aqui.** Seu contrato é o seu role mais a mensagem de delegação. Esta skill é do Maestro; ler o resto não te dá permissão nenhuma e gasta contexto que é seu.

# SDD no Maestri

> *"Faça, ou não faça. Tentativa não há."* — aceite é binário, e gate reprovado não é entrega parcial.

**A spec é o contrato. O Arquiteto escreve o contrato, o Maestro rege a execução, e nenhum dos dois implementa.**

Código e spec divergem: a spec ganha, o código é o bug. Executor precisou inventar comportamento de produto: o contrato está incompleto — falha do Arquiteto, não dele. Agente falhou? Diagnostique, refine contrato ou delegação, reatribua. Você nunca vira o implementador reserva.

## Pré-condição

Só se aplica com **CLI `maestri` e Modo Maestro neste terminal** (`maestri` fora do PATH: use `"$MAESTRI_CLI"`). Sem Maestri, use `spec-driven-dev` e siga sem perguntar. Comando respondeu "This terminal is not the Maestro": peça ao usuário para ligar o Modo Maestro neste terminal.

Primeiros comandos de toda sessão: `maestri list` e `maestri floor list`. Use só o que apareceu — **nunca infira estado oculto do canvas**, nunca chute flag (`maestri <comando> --help`). Nota-guia conectada (`maestro-guia*` / `maestro-guide*`): leia antes de agir, ela vence esta skill.

## Os papéis

| Papel | Faz | Molde de role |
|---|---|---|
| **Maestro** (você, no Ground) | Abrir a feature, partição em WPs, recrutamento, delegação, lanes, permissões, painel, relatório. Zero código, zero spec. | `agents/maestro.md` |
| **Maestro reserva** | Standby no Ground, em outra conta ou agente. Assume se a sua cota acabar. | `agents/maestro-reserva.md` |
| **Arquiteto** | Descoberta com o usuário, `spec.md` e `plan.md`, emenda de contrato. Preset mais capaz. | `agents/arquiteto.md` |
| **Engineer** (1–N) | Implementa a WP nos paths que ela possui. Sem git de escrita, sem spec. | `agents/engineer.md` |
| **Reviewer** | Valida WP contra aceite, via diff e evidência. Sem código. | `agents/reviewer.md` |
| **Git Master** | Stage, commit, push, PR. Dono único da escrita no git. Preset mais barato. | `agents/git-master.md` |

Os moldes viram **um role por papel** (`SDD Maestro`, `SDD Engineer`, `SDD Reviewer`…), cadastrados de uma vez por `scripts/papeis.sh` — no Claude Code, `/sdd-maestri:papeis` — como globais, e reaproveitados entre workspaces, features e partituras. O que muda por feature — paths, aceite, WP — vai no `tasks.md` e na mensagem de delegação, nunca no role: reescrever role reinicia o agente e apaga o histórico dele.

**Contrato e regência são separados de propósito.** O Arquiteto lê o código e conversa com o usuário; o Maestro nunca precisa fazer nenhum dos dois, e por isso rege sem carregar esse contexto.

## Cinco regras que não se negociam

1. **Um dono por path.** Dois agentes ativos nunca editam o mesmo arquivo — nem os de `.claude/specs/`.
2. **Escrita no git é só do Git Master.** Leitura (`status`, `diff`, `log`) é livre. A única exceção é o branch que `maestri floor create` cria junto com o andar, no modo andar.
3. **Nada destrutivo ou externo sem autorização explícita** — merge, `floor land`, `floor delete`, deploy, release, PR, ou deletar qualquer coisa do canvas.
4. **Handoff é por arquivo.** Não está na spec, no `tasks.md`, em `decisoes.md` ou no git: não existe.
5. **Quem produz não aprova.** Reviewer independente, de preferência em preset diferente.

## Onde a feature roda

Uma feature = um branch `feat/NNN-slug`. Onde ele fica, **o usuário escolhe** — pergunte uma vez, ao abrir a primeira feature:

> "Rodo a feature no Ground — no seu checkout, num branch `feat/NNN-slug`, uma feature por vez — ou num andar isolado, com worktree próprio, que permite paralelizar features sem mexer no seu checkout? Para uma feature por vez, recomendo o Ground."

| Modo | Branch e checkout | Quando |
|---|---|---|
| **Ground** (recomendado) | Git Master cria o branch no checkout do workspace; o time trabalha ali | uma feature por vez |
| **Andar** | `maestri floor create "NNN-slug" --branch feat/NNN-slug`: worktree próprio, recrutas com `--floor` → `references/partitura.md` | features em paralelo, ou o usuário não quer o checkout dele trocando de branch |

Guarde a resposta como `Modo:` na `regencia` e não pergunte de novo — o usuário muda quando quiser. Feature nova com outra ainda ativa no Ground: aí o andar deixa de ser opção, proponha. Workspace sem git: Ground, sem branch.

Você fica no Ground nos dois modos. Os arquivos ficam no checkout da feature:

```
<checkout da feature>/.claude/specs/
├── INBOX.md · ROADMAP.md · schema.md       ← do Arquiteto
├── current/001-login/
│   ├── spec.md · plan.md                   ← do Arquiteto
│   └── tasks.md · tasks-done.md · equipe.md · bloqueios.md · decisoes.md   ← seus
└── archive/<dominio>/ + INDEX.md
```

`<checkout da feature>` é o diretório do workspace no modo Ground, ou o caminho que `maestri floor list` imprime no modo andar. Disco é a fonte da verdade e vai versionado no branch da feature. No canvas ficam só o painel e o status — notas não cruzam andares, então nenhum executor depende de nota.

Uma WP (30–90 min) = uma fronteira de propriedade de arquivos. Entrega = destino do branch da feature: PR, merge ou o branch fica (no modo andar, pelo `floor land` — o pouso). Time salvo = **partitura**.

## O ciclo

1. **Inventariar** — `maestri list`, `floor list`, `partitura list`, `role list`, `preset list`, nota-guia, nota `regencia`. Faltou papel SDD no `role list`: `scripts/papeis.sh`. Sem reserva no workspace: monte → `references/recrutamento.md`
2. **Onde rodar** — Ground ou andar, pela `regencia` ou perguntando (acima). Andar: `floor create`, com `--partitura` se houver uma que sirva → `references/partitura.md`
3. **Contratar** — recrute o Arquiteto (no andar, se for o modo) e **passe a bola**: diga ao usuário o nome exato do terminal, porque a descoberta acontece lá. Recrute o Git Master enquanto isso. → `agents/arquiteto.md`, `references/descoberta.md`
4. **Conferir** — o Arquiteto devolve `spec.md`, `plan.md` e as fronteiras de arquivo sugeridas. Aceite binário e fronteira explícita, ou devolve.
5. **Particionar** — WPs com paths que possui, fora de escopo, aceite, evidência. Dependência real vira onda.
6. **Recrutar e delegar** — presets descobertos, toda delegação termina com a linha de *ask back* → `references/recrutamento.md`
7. **Integrar** — cada *ask back* move uma lane: você atualiza `tasks.md`, painel e status → `references/painel.md`
8. **Supervisionar** — prompt de permissão, cota esgotada, agente caído: a rotina `sdd-vigia` te acorda, você resolve dentro da regra → `references/supervisao.md`
9. **Entregar** — com autorização explícita do usuário → `references/partitura.md`

Protocolo completo, autoridade de decisão e autochecagem de ciclo: **`agents/maestro.md`** — leia antes de agir.

## Quando NÃO usar

Tarefa que um agente conectado já resolve sozinho · bug de 10 linhas · protótipo descartável · terminal fora do Maestri.

**Sem Arquiteto, mas com o resto:** feature de uma WP e um executor, ou iteração pequena sobre spec que já existe — o Maestro acumula o papel e registra em `decisoes.md`. Na dúvida sobre o tamanho, recrute: spec ruim custa mais que um terminal.

## Precedência

Nota-guia → escopo do papel ativo → `spec.md` → `plan.md` → `CLAUDE.md` → pedido no chat.

Pedido que viola o escopo do papel ativo não é atendido: peça troca de papel ou ajuste da spec.
