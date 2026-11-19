# Painel e status do andar

O `tasks.md` é a fonte da verdade das lanes. O usuário tem duas leituras dele, as duas suas — é documento de orquestração, não delegue:

- **Status do andar** — uma linha na sidebar, visível de qualquer lugar. Responde "anda ou travou?".
- **Painel** — nota no seu andar (o Ground). Responde "onde estamos?" em três segundos.

Atualize os dois a cada mudança de lane ou de onda. Nunca edite o painel à mão: ele é derivado por inteiro a cada regeneração, não é estado.

## Status do andar

```bash
maestri floor status "WP-03 em revisão · onda 2" --floor "001-login" --progress 4/9
maestri floor status "Decisão de provedor de e-mail com o usuário" --floor "001-login" --state blocked
maestri floor status "9/9 prontas, PR pronto para autorizar" --floor "001-login" --state review
```

`--floor` é o andar da feature, ou `"Ground"` no modo Ground. Uma linha curta (corta em 120 caracteres). `--progress` é WPs prontas sobre total. `blocked` e `review` notificam o usuário — use só quando forem verdade. Vários andares ativos: um resumo no Ground com `--floor "Ground"`.

## Painel

Nota markdown, nome fixo `painel-<NNN-slug>`, arquivada no fichário `SDD`. Nada de HTML nem portal.

```bash
maestri note create "<conteúdo>" --name "painel-001-login" --stack "SDD" --color blue   # só na primeira publicação
maestri note write "painel-001-login" "<conteúdo>"                                         # a cada atualização
```

`--name` fixa o nome, que senão seguiria a primeira linha. Sempre `write` (substituição total), nunca `edit` — o conteúdo novo já é a versão final. Nunca rode `create` duas vezes para a mesma feature: vira nota duplicada. Não sabe se já existe? `maestri list`. Conteúdo é decodificado: `\n` vira quebra de linha; para manter uma barra invertida literal, dobre-a.

## Conteúdo

Ordem importa:

1. **Resumo** — uma linha: feature, WPs por lane, onda atual, bloqueios abertos.
2. **Kanban das WPs** — quatro seções (Fazendo, Revisão, Planejado, Pronto), uma linha por WP: ID, título, dono, paths que possui, critério de aceite. WP devolvida ganha `⚠` e o motivo na mesma linha.
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
- WP-01 — rotas base | Rey | `src/auth/routes.ts` | a1b2c3d

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
