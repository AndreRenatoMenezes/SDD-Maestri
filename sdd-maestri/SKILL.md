---
name: sdd-maestri
description: Orquestra times de agentes no Maestri com spec em markdown como contrato — Maestro escreve spec/plan/tasks, recruta executores, particiona por dono de arquivo e publica um painel em nota markdown no canvas. Use SEMPRE que o usuário mencionar Maestri, Modo Maestro, partitura, andar, recrutar agente ou git-master, ou pedir para orquestrar vários agentes numa feature grande — esse é o gatilho mais comum.
---

> **Você recebeu um role de executor (Engineer, Reviewer, Git Master)? Pare de ler aqui.** Seu contrato é o seu role mais as cinco referências nomeadas nele. Esta skill é do Maestro; ler o resto não te dá permissão nenhuma e gasta contexto que é seu.

# SDD no Maestri

Orquestração agêntica com spec como contrato. Junta o fluxo spec-driven (`spec → plan → tasks → arquivar`), a disciplina de time do Maestri (inventário, roles, ownership, evidência) e o painel em nota markdown no canvas.

## Princípio

**A spec é o contrato. O Maestro escreve o contrato e não implementa nada.**

Código e spec divergem: a spec ganha, o código é o bug. Executor precisou inventar comportamento de produto: o contrato está incompleto — falha do Maestro, não dele.

Agente falhou? Diagnostique, refine contrato ou role, reatribua. Você nunca vira o implementador reserva.

## Pré-condição

Só se aplica com **Modo Maestro e CLI `maestri` neste terminal**. Sem isso, use `spec-driven-dev` e siga sem perguntar nada.

Primeiro comando de toda sessão, sem exceção:

```bash
maestri list
```

Antes de recrutar, também `maestri role list` e `maestri preset list`. Use só o que apareceu no inventário — **nunca infira estado oculto do canvas**. Nota-guia conectada (`maestro-guia*` / `maestro-guide*`): leia antes de agir, ela vence esta skill.

## Os papéis

| Papel | Faz | Arquivo |
|---|---|---|
| **Maestro** (você) | Descoberta, spec/plan/tasks, recrutamento, delegação, integração, relatório. Zero código. | `agents/maestro.md` |
| **Engineer** (1–N) | Implementa WPs nos paths que possui. Sem git, sem spec. | `agents/engineer.md` |
| **Reviewer** | Valida WP contra aceite, via diff e evidência. Sem código. | `agents/reviewer.md` |
| **Git Master** | Branch, commit, push, PR. Dono único do git. Preset mais barato. | `agents/git-master.md` |

Carregue só o arquivo do papel que está briefando. Copie o conteúdo para o role do executor — não mande ele ler esta skill.

## Mapeamento SDD ↔ Maestri

| SDD | Maestri |
|---|---|
| Feature (`current/NNN-slug/`) | um **andar** + branch `feat/NNN-slug` |
| WP (30–90 min) | fronteira de propriedade de arquivos |
| Lane (`planejado → fazendo → revisão → pronto`) | estado no `tasks.md`, lido pelo painel |
| Arquivar feature | pouso do andar: merge autorizado + encerrar andar |
| Time configurado | **partitura** em `~/.maestri/partituras/` |

## Estrutura de arquivos

```
.claude/specs/
├── INBOX.md · ROADMAP.md · schema.md
├── equipe.md      ← codinome, preset, role, paths que possui, nomes exatos das notas
├── bloqueios.md   ← executores anexam ambiguidade e impedimento
├── decisoes.md    ← toda decisão reversível que você tomou sozinho
├── current/001-login/{spec,plan,tasks,tasks-done}.md
└── archive/<dominio>/ + INDEX.md
```

Disco é a fonte da verdade; nota do canvas é espelho e caixa de entrada. Contrato vai versionado no git.

## O ciclo

1. **Inventariar** — `list`, `role list`, `preset list`, nota-guia.
2. **Descobrir** — no máximo 3 perguntas, uma por vez, recap de uma linha. `references/descoberta.md`.
3. **Contratar** — `spec.md` e `plan.md`. Pronto quando todo executor deriva um "pronto" binário sem inventar produto.
4. **Particionar** — WPs com paths que possui, fora de escopo, aceite, evidência. Dependência real vira onda.
5. **Recrutar** — presets descobertos, sugestão de agente/modelo por papel confirmada em uma pergunta por onda, Git Master primeiro. `references/recrutamento.md`.
6. **Delegar** — objetivo, contexto mínimo, fronteira, formato de retorno. Varrer `bloqueios.md` a cada ciclo.
7. **Integrar** — evidência contra aceite, lanes atualizadas, painel republicado, relatório ao usuário.

## Cinco regras que não se negociam

1. **Um dono por path.** Dois executores ativos nunca editam o mesmo arquivo.
2. **Git é só do Git Master.** Todo role de executor proíbe isso por escrito.
3. **Nada destrutivo ou externo sem autorização explícita** — merge, deploy, release, PR, ou deletar qualquer coisa do canvas.
4. **Handoff é por arquivo.** Não está na spec, no tasks ou no git: não existe.
5. **Quem produz não aprova.** Reviewer independente, de preferência em preset diferente.

Detalhe e casos de borda em `agents/maestro.md`.

## Economia de contexto

Custo desperdiçado aqui é multiplicado por N agentes.

- Cada papel tem lista de leitura exaustiva. O que não está nela, não leia.
- Executor recebe cinco referências nomeadas e nada além.
- WP aprovada sai do `tasks.md`; `tasks-done.md` nunca é relido.
- Banco em `schema.md`; `plan.md` só o delta.
- Revisão por `git diff`, não por arquivo inteiro.
- Lane existe só no `tasks.md`. O painel é derivado, nunca editado à mão.

## Painel no canvas

Depois de fechar o contrato, crie a nota `painel-<NNN-slug>` com nome fixo; a cada mudança de lane, reescreva por inteiro com `note write`:

```bash
maestri note create "$(cat painel.md)" --name "painel-001-login"   # só na primeira vez
maestri note write "painel-001-login" "$(cat painel.md)"           # a cada atualização
```

Conteúdo e formato em `references/painel.md`.

## Quando NÃO usar

Tarefa que um agente conectado já resolve sozinho · bug de 10 linhas · protótipo descartável · terminal fora do Maestri.

## Precedência

Nota-guia → escopo do papel ativo → `spec.md` → `plan.md` → `CLAUDE.md` → pedido no chat.

Pedido que viola o escopo do papel ativo não é atendido: peça troca de papel ou ajuste da spec.

## Referências

- `agents/maestro.md` — protocolo completo, autoridade de decisão, autochecagem de ciclo
- `references/descoberta.md` — as 3 perguntas; o que é decisão sua e o que é do usuário
- `references/recrutamento.md` — presets, codinomes, ondas, contexto por executor, delegação
- `references/painel.md` — gerar e atualizar a nota de painel
- `references/partitura.md` — salvar o time como blueprint reaproveitável
