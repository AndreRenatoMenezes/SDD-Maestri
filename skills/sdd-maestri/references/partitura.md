# Andar, partitura e entrega

## Abrir o andar

Só no **modo andar** — o usuário escolheu (`SKILL.md`, "Onde a feature roda"). No modo Ground, quem abre a feature é o Git Master, com o branch no checkout do workspace.

```bash
maestri floor create "001-login" --branch feat/001-login                         # time montado à mão
maestri floor create "001-login" --branch feat/001-login --partitura "sdd-padrao"  # time salvo, já conectado a você
```

O andar é um worktree do repositório no próprio branch: o time trabalha lá sem tocar no checkout do Ground. Branch já existe: `--existing-branch`. Revisar um PR aberto em vez de feature nova: `--pull-request <N>`. Workspace com vários repositórios: `--from <pasta>`. Workspace sem git ou sandbox Docker: o Maestri cria um andar simples e avisa — então os arquivos de spec vivem no Ground.

Criar o andar é aditivo, mas o modo é do usuário: registre a escolha dele em `decisoes.md`.

## Partitura como blueprint

Partitura é um time salvo pelo usuário: agentes com roles e presets, notas, bandas e ropes. Ela mata o custo de montagem a cada feature — o que muda entre features é o conteúdo das specs, não a topologia do time.

```bash
maestri partitura list
maestri partitura insert "sdd-padrao"                       # modo Ground: no seu andar
maestri partitura insert "sdd-padrao" --floor "001-login"   # modo andar, num andar que já existe
```

`insert` (ou `floor create --partitura`) conecta você aos agentes dela e devolve os nomes: use exatamente esses nomes em `equipe.md`. Os roles SDD (`references/recrutamento.md`) têm de existir neste workspace — partitura global trazida de outro projeto aponta para roles que talvez não estejam aqui; confira em `role list`.

**Salvar só quando o usuário pedir.** Depois de um time que funcionou bem, ofereça:

```bash
maestri partitura create "sdd-padrao" "Leia" "Rey" "Finn" "Ahsoka" "Chewie" --without-me --description "Arquiteto + 2 Engineers + Reviewer + Git Master"
```

Nomeie os agentes e use `--without-me`: Maestro e reserva não entram, a partitura é só o time da feature. Se a CLI recusar agentes de outro andar, o usuário salva pelo app. Por padrão ela salva comandos e texto das notas, não o histórico de conversa — é o que se quer. `update` e `delete` também só a pedido.

| Partitura | Composição | Quando |
|---|---|---|
| `sdd-solo` | 1 Engineer + Git Master | feature pequena, uma fronteira só — Maestro acumula o contrato |
| `sdd-padrao` | Arquiteto + 2–3 Engineers + Reviewer + Git Master | o caso comum |
| `sdd-fundacao` | Arquiteto + Engineer capaz + Reviewer capaz + Git Master | schema, auth, contrato entre camadas |
| `sdd-correcao` | 1 Engineer + Reviewer | onda de correção depois de gate reprovado — contrato já existe |

O Maestro reserva não entra em partitura de feature: é um por workspace, no Ground.

Nomes são sugestão. O que importa é ter poucos arranjos conhecidos em vez de improvisar a topologia a cada feature.

Regras: preset é referência, não modelo hardcoded. Comando de inicialização com token dentro não vai para partitura.

## Entrega da feature

Vale nos dois modos. No modo Ground não há andar para pousar: a entrega é decidir o destino do branch, que já está no checkout do usuário. **Pouso** é só o nome do `floor land`, no modo andar — não use a palavra com quem trabalha no Ground.

Acontece quando **todas as WPs estão em `pronto`** e não há bloqueio aberto:

1. Status em `--state review`.
2. Git Master commita os arquivos de spec pendentes e prepara título e descrição do PR.
3. Você apresenta ao usuário **três saídas, cada uma com o comando exato do modo da feature**, e espera que ele escolha uma pelo nome:

   | Saída | Modo Ground | Modo andar | Toca o branch de integração? |
   |---|---|---|---|
   | **PR** | Git Master: push e `gh pr create` | igual | não — o merge acontece no PR, por quem revisar |
   | **Deixar o branch** | nada a rodar: o branch fica | `maestri floor land "<andar>"` (remove o andar, o branch fica no projeto) | não |
   | **Merge local** | Git Master: `git checkout <branch>` e `git merge feat/<NNN-slug>` | `maestri floor land "<andar>" --into <branch>` | **sim** — merge no `<branch>` agora |

   Resposta que não nomeia uma saída ("pode entregar", "pode pousar", "pode seguir", "ok") não escolhe: pergunte qual. **Merge local exige que o usuário diga merge ou nomeie o branch de destino** — nunca deduza `--into` de uma autorização genérica.
4. Com a escolha, escreva **agora** a última entrada de `decisoes.md`: a saída escolhida e **as palavras do usuário, copiadas**. Sem essa entrada, o comando da saída não roda. Escreva também o relatório final — depois do arquivamento, você não escreve mais nos arquivos da feature.
5. Avise o Arquiteto da saída escolhida, para ele marcar a spec como ✅ implementada no `ROADMAP.md` e no `IDEIAS.md` do Ground — sem Arquiteto no canvas, a próxima descoberta de backlog reconcilia pelo `archive/`. Git Master arquiva a feature (`archive/<dominio>/`) e confirma `git status` limpo. Registro que surgiu depois: ele commita antes de seguir.
6. Rode **só a saída escolhida**, exatamente como apresentada — trocar a saída, ou acrescentar `--into` depois de uma recusa do land, exige nova escolha do usuário. PR no modo andar: o Maestri acompanha review, checks e merge no próprio andar. Land: rode do Ground; ele recusa trabalho não commitado e conflito, dizendo os arquivos — devolva ao Git Master e rode de novo o mesmo comando.
7. Tire a feature da `regencia`. Reserva, `sdd-vigia` e `sdd-sucessao` ficam para a próxima: sem feature em andamento, as rotinas não disparam.
8. Modo andar, depois do PR mergeado: `floor delete`. Em qualquer caminho, `dismiss` do time — só se o usuário pedir.

Feature parcial não arquiva. Termine ou cancele explicitamente — cancelada também vai para o archive, com o motivo registrado.
