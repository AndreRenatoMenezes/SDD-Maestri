# Recrutamento

## Antes de recrutar

```bash
maestri list            # time, notas, bandas — e o que cada recruta já tem conectado
maestri floor list      # andares, branch, checkout, status
maestri partitura list  # time salvo que já sirva? prefira inserir a montar à mão
maestri role list       # roles SDD já criados neste workspace
maestri preset list     # a única fonte de "quais agentes e contas existem"
```

Agente conectado com papel que serve? **Delegue a ele** — não recrute duplicata. Role quase certo? `maestri role edit`, não role novo.

**Model-agnostic, sempre.** Não hardcode provedor, modelo, comando, nível de esforço, CLI de agente ou flag de bypass de permissão. Use o que o `preset list` devolveu. **Nunca adicione flag de pular permissão.**

## Roles: um por papel, cadastrados de uma vez

Os seis papéis — `SDD Maestro`, `SDD Maestro Reserva`, `SDD Arquiteto`, `SDD Engineer`, `SDD Reviewer`, `SDD Git Master` — saem dos moldes por um script, **globais** por padrão: cadastrados uma vez, valem em todo workspace, e projeto novo já começa com eles. Faltou algum no `role list`, ou a skill foi atualizada:

```bash
sh <diretório desta skill>/scripts/papeis.sh            # no Claude Code: /sdd-maestri:papeis
sh <diretório desta skill>/scripts/papeis.sh --workspace # só neste workspace
```

É idempotente: o que existe é reescrito com o molde atual, e cada papel leva no cabeçalho o caminho da skill. Nenhum molde nomeia o Maestro — o executor responde a quem assinou a última delegação, e a reserva lê o Maestro ativo na `regencia` — e é isso que deixa o mesmo texto servir a qualquer workspace e a reserva assumir sem reescrever role. Não monte role à mão com `cat`: o Arquiteto perde `descoberta.md`, e os papéis perdem o caminho da skill.

**O seu terminal também tem papel:** `SDD Maestro`. Com ele, o protocolo sobrevive a compactação de contexto e reinício — sem ele, você depende de reler a skill. Você não atribui papel a si mesmo: peça ao usuário para atribuir pelo app, entre features, porque reinicia o agente.

Paths, aceite e WP **nunca** entram no role: mudam a cada onda, e trocar role reinicia o agente.

## Recrutar

```bash
maestri recruit "Rey" --preset "<preset>" --role "SDD Engineer" --floor "001-login" --color green --icon hammer
```

- `--floor` só no modo andar: põe o recruta no checkout do andar, ligado a você por `ask`/`check`. No modo Ground, sem `--floor` — ele nasce no checkout do workspace, com você.
- Cor por papel, para o humano ler o canvas de longe: Arquiteto `purple`, Engineer `green`, Reviewer `yellow`, Git Master `orange`.
- Não conecte executores entre si nem crie banda: tudo passa por você, que move as lanes. Banda só se o usuário pedir.
- A única conexão extra é a da reserva: `maestri connect "<Reserva>" "Rey"` logo depois de cada recruta, para ela alcançar o time se assumir.
- **Recruta pronto antes do primeiro `ask`.** O agente sobe com o que ele quiser: menu de atualização, "Do you trust the files in this folder?", login, escolha de modelo. Delegação digitada num menu responde o menu — no teste, ela disparou uma atualização do CLI e derrubou o agente. Rode `maestri check` até ver o prompt normal do agente; resolva menu de confiança pela política de `references/supervisao.md`, e atualização ou login pergunte ao usuário.

## Escolher preset e conta

Cada preset é uma combinação de agente (Claude Code, Codex, Gemini CLI, OpenCode, ou o que o usuário configurou) e modelo. Nome de preset que não deixa claro o que está por trás: `maestri preset show "<nome>"` antes de usá-lo em papel de alto impacto.

| Tipo de trabalho | Preset |
|---|---|
| Arquiteto — descoberta e contrato | o mais capaz disponível, sem exceção |
| fundação, segurança, modelo de dados, regra de negócio, contrato entre camadas, raio grande | o mais capaz disponível |
| trabalho mecânico e delimitado | um mais rápido |
| git, commit, PR | o mais barato |
| revisão de trabalho crítico | capaz — e **diferente** do preset (e, se possível, do agente) que implementou |

Quando um resultado errado causaria retrabalho do time inteiro, prefira confiabilidade a velocidade.

Preset com várias contas (`accounts: "Default", "Work"` no `preset list`): distribua executores paralelos entre elas com `--account`, para uma onda não esgotar o limite de uma assinatura só.

Ao montar a coluna **Reserva**, lembre que cota é por conta: duas reservas na mesma conta caem juntas. A conta do Maestro reserva é só dele — nunca vira reserva de executor.

**Sugira, não decida em silêncio.** Para cada papel da onda, cruze o tipo de trabalho com os presets e contas disponíveis numa sugestão de uma frase. Presets equivalentes: prefira o já em uso por outro executor da mesma onda.

Apresente **uma vez por onda**, nunca um agente por vez:

> "Onda 1 — sugiro: Rey (Engineer, `<preset>`) e Finn (Engineer, `<preset>`, conta Work) no mais capaz por mexerem em auth/schema; Ahsoka (Reviewer) num preset diferente do deles. Se alguém esgotar a cota, troco para a outra conta do mesmo agente, ou para `<preset>`. Confirma ou troca algum?"

A troca por cota vai na mesma pergunta: confirmada, ela vira a coluna **Reserva** do `equipe.md` e você troca sem perguntar de novo (`references/supervisao.md`).

**Antes de cada pergunta de onda, `maestri check` no Maestro reserva.** Reserva em standby que perde a cota não avisa ninguém: a sucessão só passa a ser pulada (`skippedWhileBusy`), e você descobre quando precisar dela. Sem cota, caída ou presa em retry: diga na mesma pergunta e sugira outro preset ou conta para ela — nunca uma conta que um executor usa ou tem como reserva.

- Confirmou ou respondeu genérico ("pode seguir", "você escolhe") → siga a sugestão, registre em `decisoes.md`, recrute.
- Trocou algum → use a escolha dele, registre em `equipe.md`, sem reabrir pergunta para os que não tocou.

Pule a pergunta e decida direto (registrando em `decisoes.md`) em feature de uma WP e um executor, e em preset já validado nesta sessão para o mesmo papel e tipo de trabalho.

## Codinomes

Curtos e distintivos. **O role descreve o trabalho; o codinome dá identidade.** Nada de "Engineer 1" ou do nome do papel — vira confusão de handoff.

Uma palavra, sem hífen, sem acento, sem `@`. `ask`, `check` e `--replace` casam por nome exato, e o canvas acrescenta `(2)` a um nome repetido: confira em `maestri list` e use o nome que o `recruit` devolveu.

Todos de **um mesmo universo** ajuda o humano a lembrar quem é quem — os exemplos aqui usam Star Wars. O tema é do usuário; varie entre times. O nome não pode sugerir hierarquia ou comportamento que o role não dá.

Registre em `current/<NNN-slug>/equipe.md`:

```md
| Codinome | Papel | Preset | Conta | Reserva | Andar |
|---|---|---|---|---|---|
| Leia | Arquiteto | <preset capaz> | Default | conta Work | 001-login |
| Rey | Engineer | <preset> | Default | conta Work | 001-login |
| Finn | Engineer | <preset> | Work | <outro preset> | 001-login |
| Ahsoka | Reviewer | <preset> | Default | <outro preset> | 001-login |
| Chewie | Git Master | <preset barato> | Default | conta Work | 001-login |
| Obi | Maestro reserva | <preset Maestro> | <outra conta> | — | Ground |
```

Quem possui qual path mora na WP, não aqui.

## Ordem de montagem

1. **Maestro reserva** e a nota `regencia`, se ainda não existem no workspace — seção abaixo.
2. **Onde rodar** — o `Modo` da `regencia`, ou pergunte (`SKILL.md`). Modo andar: crie o andar (ou insira a partitura nele).
3. **Arquiteto**, antes de existir contrato. Diga ao usuário o nome exato do terminal (e o andar, se houver) para a descoberta começar lá.
4. **Git Master**, enquanto a descoberta corre — não depende do contrato. Diga a ele o modo: no Ground, é ele quem cria o branch. Crie a rotina `sdd-vigia` (`references/supervisao.md`).
5. Engineers da onda 1 (fundação), só depois de a spec fechar e você particionar.
6. Reviewer.
7. Engineers das ondas seguintes — só quando a evidência da dependência estiver disponível. Reaproveite um Engineer livre antes de recrutar outro.

Prefira 3–5 frentes concorrentes e mais ondas, em vez de mais agentes. Respeite a capacidade real do workspace.

O Arquiteto **fica conectado** depois do handoff: ele é quem emenda o contrato quando aparece ambiguidade. Não dispense no fim da descoberta.

## Maestro reserva

Um terminal em standby no Ground que assume se a sua cota acabar. Um por workspace, servindo todas as features. Pule só em `sdd-solo` ou se o usuário dispensar.

**Preset:** precisa de Modo Maestro (`Maestro: on` em `maestri preset show`) e de **outra conta ou outro agente** que o seu — reserva na mesma conta esgota junto. Nenhum preset serve? Proponha ao usuário criar um e só crie com o sim dele, porque presets sincronizam entre os Macs dele:

```bash
maestri preset create "<Agente> Maestro" --command "<comando do preset base>" --account "<outra conta>" --maestro on --quick-start off
```

**Montagem**, uma vez:

```bash
M="<seu nome>"   # o role SDD Maestro Reserva já existe: scripts/papeis.sh
maestri recruit "Obi" --preset "<preset Maestro>" --role "SDD Maestro Reserva" --color purple --icon seal
maestri note create "<conteúdo da regência>" --name "regencia" --stack "SDD" --color purple
maestri connect "regencia" "Obi"
maestri routine create "sdd-sucessao" --every 15m --no-notify --terminal "Obi" \
  --pre-run 'D="$MAESTRI_WORKSPACE_DIR"; { echo "$D"; git -C "$D" worktree list --porcelain 2>/dev/null | sed -n "s/^worktree //p"; } | while IFS= read -r w; do find "$w/.claude/specs/current" -mindepth 1 -maxdepth 1 -type d 2>/dev/null; done | grep -q . && echo "feature em andamento"' \
  --command "SDD sucessão: rode maestri check \"$M\". Sem sinal de cota esgotada, sessão caída ou standby, responda só ok. Com sinal, siga seu role."
```

A `regencia` diz, em poucas linhas: `Maestro ativo`, `Reserva`, `Modo` (Ground ou andar, a escolha do usuário) e cada feature ativa com onde roda e o caminho do checkout. Atualize quando abrir ou entregar uma feature. Ela fica no Ground e fora do repositório de propósito: arquivo novo no checkout do Ground faria o `floor land` recusar.

A rotina não lê a sua tela — o `--pre-run` não alcança o canvas (`references/supervisao.md`, "Rotinas de vigia"). Ela só acorda a reserva, que faz o `check` e, com você saudável, responde `ok`: um custo pequeno a cada 15 min, e só com feature em andamento. `--no-notify` é obrigatório, senão o usuário recebe uma notificação por disparo. Teste uma vez com `maestri routine run "sdd-sucessao"` — aqui funciona, porque o alvo é a reserva, ociosa.

**Ao começar qualquer sessão,** leia a `regencia`: se o `Maestro ativo` não é você, você é a reserva agora — siga `agents/maestro-reserva.md`.

**A sucessão gira junto com a regência.** Quem assume não desativa a `sdd-sucessao`: aponta ela para quem saiu, checando quem entrou. Assim sempre há alguém de olho no Maestro ativo, inclusive quando é a reserva que perde a cota ou o contexto. Sem cota, quem saiu só começa a responder aos disparos depois do reset.

## Delegação

Quatro partes e a linha de *ask back*, sempre:

```text
WP-03 — sessão. Leia a WP-03 em .claude/specs/current/001-login/tasks.md.
Objetivo: <resultado exigido, não receita>.
Fronteira: só os paths em Possui; src/ui/** é do Finn.
Retorno: saída real de <comando de evidência>.
Ao terminar, rode: maestri ask "<seu nome>" "WP-03 entregue: <relatório>"
```

Contexto mínimo: o role já tem o protocolo, então a mensagem carrega só a WP. Nada de colar a spec — o executor lê o arquivo.

**Arquiteto** é diferente: delegue com o pedido do usuário como veio, o caminho `current/<NNN-slug>/` e o lembrete de responder o handoff por `maestri ask`. O workspace ele investiga sozinho.

**Revisão:** WP, paths que ela possui e o relatório do Engineer, colado. **Commit:** WP, título, paths, veredito.

Lote só para alvos genuinamente independentes: `maestri ask --batch '{"Rey": "...", "Finn": "..."}'`. O JSON usa escape padrão; a resposta é um array `{name, output}` — **case por `name`, nunca por posição**. Pergunta rápida (precisa da resposta agora): timeout pela tarefa mais lenta, 1 a 10 min. **Delegação com *ask back*: timeout curto, ~2 min** (o da sua ferramenta de shell; `maestri ask` não tem flag de timeout) — o relatório chega como prompt novo de qualquer jeito, e ficar bloqueado no `ask` impede a `sdd-vigia` de te alcançar. Estourou: siga "Espera e status" em `agents/maestro.md`.

## Substituir e dispensar

```bash
maestri recruit "Rey" --preset "<preset novo>" --replace "Rey"  # troca o agente no lugar
maestri recruit --replace "Rey" --account "Work"                # mesmo agente, outra conta
maestri role assign "Rey" "SDD Reviewer"                        # troca só o papel
```

Os três mantêm nome, posição, conexões e rotinas, e **reiniciam o processo sem o histórico de conversa**. Garanta que o estado está nos arquivos antes e mande a delegação de novo depois. Espere o agente voltar ao prompt normal (`maestri check`) antes do próximo comando nele: um `role assign` dado enquanto ele ainda reinicia não pega, e o agente sobe sem role e sem erro.

`maestri dismiss "Nome"` encerra o terminal e remove o nó — nota ou portal ligado só a ele fica órfão, e só o usuário religa. É remoção: cai na regra 3. Não dispense executor só porque a WP fechou: reaproveite na próxima onda, ou deixe até a entrega e pergunte.
