# Painel no canvas

O `tasks.md` é a fonte da verdade das lanes. O painel é a **leitura** dele — o que dá ao humano a visão panorâmica que justifica o canvas.

Gere depois de fechar o contrato e republique a cada mudança de lane ou de onda. Nunca edite o painel à mão: ele é derivado, não é estado.

## Nota, não HTML

O painel é uma **nota markdown no canvas**, criada e mantida com `maestri note`. Nada de arquivo HTML nem portal: markdown é mais barato de gerar, mais barato de reler e edita in-place sem reabrir nada no navegador.

O painel é **derivado por inteiro** a cada regeneração — não é uma nota que cresce por acréscimo como `bloqueios.md`/`decisoes.md`. Por isso ele sempre usa `write` (substituição total), nunca `edit` (troca de trecho): `write` é o comando certo quando o conteúdo novo já é a versão final, não um patch sobre o texto anterior.

Nome fixo por feature, para sempre achar a mesma nota:

```
painel-<NNN-slug>
```

Primeira publicação:

```bash
maestri note write "painel-001-login" "$(cat painel.md)"
```

Nas atualizações seguintes, **reescreva a mesma nota** — nunca crie uma nova para a mesma feature:

```bash
maestri note write "painel-001-login" "$(cat painel.md)"
```

Se a nota ainda não existir, confirme com `maestri list` se `note write` a cria automaticamente ou se é preciso um `note create "painel-001-login"` antes — comportamento não documentado publicamente, valide uma vez por sessão.

## Conteúdo

Ordem importa — o humano abre a nota para responder "onde estamos?" em três segundos.

1. **Resumo** — feature e domínio; WPs por lane (`3 planejado · 1 fazendo · 1 revisão · 4 pronto`); onda atual; bloqueios abertos. Uma linha.
2. **Kanban das WPs** — quatro seções (`## Planejado`, `## Fazendo`, `## Revisão`, `## Pronto`), uma linha por WP: ID, título, codinome do dono, paths que possui, critério de aceite. WP devolvida pelo Reviewer ganha `⚠` e o motivo na mesma linha.
3. **Mapa de propriedade** — tabela markdown `path → dono`. É o que deixa colisão óbvia antes de virar conflito.
4. **Ondas** — lista ordenada, uma onda por item, com as WPs que a compõem e a dependência que a bloqueou até abrir. Sem diagrama: em texto, a ordem já basta para responder "o que está serializado".
5. **Critérios de aceite em aberto** — checklist da spec (`- [x]` / `- [ ]`), com o que já tem evidência marcado.
6. **Bloqueios** — um por linha: data, agente, uma frase, dono da decisão.

Conteúdo real, sempre. Nada de dado de exemplo num painel de estado — painel com número inventado é pior que painel nenhum.

## Formato

```markdown
# Painel — 001 Login

**Resumo:** 3 planejado · 1 fazendo · 1 revisão · 4 pronto · onda 2 · 1 bloqueio aberto

## Fazendo
- WP-03 — sessão | Bruma | `src/auth/**`, `src/lib/session.ts` | aceite: login mantém sessão por 7 dias

## Revisão
- WP-02 — schema de usuário ⚠ devolvida: falta índice único em email | Aster | `migrations/**`

## Planejado
- WP-04 — UI de login | Cedro | `src/ui/login/**`

## Pronto
- WP-01 — rotas base | Bruma | `src/auth/routes.ts`

## Propriedade
| Path | Dono |
|---|---|
| `src/auth/**` | Bruma |
| `migrations/**` | Aster |
| `src/ui/login/**` | Cedro |

## Ondas
1. WP-01, WP-02 — sem dependência
2. WP-03 — depende de WP-01
3. WP-04 — depende de WP-02, WP-03

## Aceite
- [x] login rejeita senha errada com mensagem genérica
- [ ] sessão expira em 7 dias

## Bloqueios
- 2026-08-15 — Aster — schema não define unicidade de email — dono: usuário
```

## Quem gera

O Maestro. É documento de orquestração, não código de produto — não delegue e não deixe executor mexer.
