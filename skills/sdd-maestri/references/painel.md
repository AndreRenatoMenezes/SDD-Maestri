# Painel no canvas

O `tasks.md` é a fonte da verdade das lanes; o painel é a **leitura** dele. Quem gera é o Maestro — é documento de orquestração, não delegue.

Gere depois de fechar o contrato e republique a cada mudança de lane ou de onda. Nunca edite à mão: ele é derivado por inteiro a cada regeneração, não é estado.

## Comandos

Nota markdown, nome fixo `painel-<NNN-slug>`. Nada de HTML nem portal.

```bash
maestri note create "$(cat painel.md)" --name "painel-001-login"   # só na primeira publicação
maestri note write "painel-001-login" "$(cat painel.md)"           # a cada atualização
```

`--name` fixa o nome, que senão seguiria a primeira linha do conteúdo. Sempre `write` (substituição total), nunca `edit` — o conteúdo novo já é a versão final, não um patch. Nunca rode `create` duas vezes para a mesma feature: vira nota duplicada solta no canvas.

## Conteúdo

Ordem importa — o humano abre a nota para responder "onde estamos?" em três segundos.

1. **Resumo** — uma linha: feature, WPs por lane, onda atual, bloqueios abertos.
2. **Kanban das WPs** — quatro seções (Fazendo, Revisão, Planejado, Pronto), uma linha por WP: ID, título, dono, paths que possui, critério de aceite. WP devolvida pelo Reviewer ganha `⚠` e o motivo na mesma linha.
3. **Propriedade** — tabela `path → dono`. É o que deixa colisão óbvia antes de virar conflito.
4. **Ondas** — lista ordenada, com as WPs de cada uma e a dependência que a bloqueou. Sem diagrama.
5. **Aceite** — checklist da spec, marcado no que já tem evidência.
6. **Bloqueios** — um por linha: data, agente, uma frase, dono da decisão.

Conteúdo real, sempre. Painel com número inventado é pior que painel nenhum.

```markdown
# Painel — 001 Login

**Resumo:** 3 planejado · 1 fazendo · 1 revisão · 4 pronto · onda 2 · 1 bloqueio aberto

## Fazendo
- WP-03 — sessão | Rey | `src/auth/**`, `src/lib/session.ts` | aceite: login mantém sessão por 7 dias

## Revisão
- WP-02 — schema de usuário ⚠ devolvida: falta índice único em email | Hera | `migrations/**`

## Planejado
- WP-04 — UI de login | Ezra | `src/ui/login/**`

## Pronto
- WP-01 — rotas base | Rey | `src/auth/routes.ts`

## Propriedade
| Path | Dono |
|---|---|
| `src/auth/**` | Rey |
| `migrations/**` | Hera |
| `src/ui/login/**` | Ezra |

## Ondas
1. WP-01, WP-02 — sem dependência
2. WP-03 — depende de WP-01
3. WP-04 — depende de WP-02, WP-03

## Aceite
- [x] login rejeita senha errada com mensagem genérica
- [ ] sessão expira em 7 dias

## Bloqueios
- 2026-08-15 — Hera — schema não define unicidade de email — dono: usuário
```
