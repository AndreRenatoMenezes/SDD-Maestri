# Recrutamento

## Antes de recrutar

```bash
maestri list          # inventário: agentes, notas, portais, andares, conexões
maestri role list     # roles existentes
maestri preset list   # presets disponíveis — a única fonte de "quais modelos existem"
```

Inspecione a árvore de time aninhada e as conexões existentes antes de conectar, substituir, atribuir ou coordenar qualquer agente.

**Model-agnostic, sempre.** Não hardcode provedor, modelo, comando, nível de esforço, CLI de agente ou flag de bypass de permissão. Use o que o `preset list` devolveu. **Nunca adicione flag de pular permissão.**

Role existente quase certo? **Atualize ou reatribua** em vez de recrutar duplicata.

## Comandos

```bash
maestri role create "Engineer-Rey" "$(cat agents/engineer.md)"   # preencha os <...> antes
maestri recruit "Rey" --preset "<preset>" --role "Engineer-Rey"  # já vem conectado a você
maestri connect "Rey" "spec-Rey"    # connect casa por nome exato, como maestri list imprime
maestri connect "Rey" "tasks-Rey"
```

## Escolher o preset

Cada preset do workspace é uma combinação de agente (Claude Code, Codex, Gemini CLI, OpenCode, Antigravity, ou o que o usuário tiver configurado) e modelo. `preset list` só devolve o **nome** — não confie nele para adivinhar o que está por trás.

| Tipo de trabalho | Preset |
|---|---|
| Arquiteto — descoberta e contrato | o mais capaz disponível, sem exceção |
| fundação, segurança, modelo de dados, regra de negócio, contrato entre camadas, raio grande | o mais capaz disponível |
| trabalho mecânico e delimitado | um mais rápido |
| git, commit, PR | o mais barato |
| revisão de trabalho crítico | capaz — e **diferente** do preset (e, se possível, do agente) que implementou |

Quando um resultado errado causaria retrabalho do time inteiro, prefira confiabilidade a velocidade.

**Sugira, não decida em silêncio.** Para cada papel da onda, cruze o tipo de trabalho com os presets disponíveis e monte uma sugestão de uma frase. Presets equivalentes: prefira o já em uso por outro executor da mesma onda. Nome de preset que não deixa claro agente e modelo: pergunte o que ele representa antes de usá-lo em papel de alto impacto.

Apresente **uma vez por onda**, nunca um agente por vez:

> "Onda 1 — sugiro: Rey (Engineer, `<preset>`) e Finn (Engineer, `<preset>`) no mais capaz por mexerem em auth/schema; Ahsoka (Reviewer) num preset diferente do deles. Confirma ou troca algum?"

- Confirmou ou respondeu genérico ("pode seguir", "você escolhe") → siga a sugestão, registre em `decisoes.md`, recrute.
- Trocou algum → use a escolha dele, registre em `equipe.md`, sem reabrir pergunta para os que não tocou.

Pule a pergunta e decida direto (registrando em `decisoes.md`) em feature de uma WP e um executor, e em preset já validado nesta sessão para o mesmo papel e tipo de trabalho.

## Codinomes

Curtos e distintivos. **O role descreve o trabalho; o codinome dá identidade.** Nada de "Engineer 1", "Engineer 2" — vira confusão de handoff. Use nomes que você digite rápido em `maestri ask` e `maestri check`.

Uma palavra, sem hífen e sem acento. `connect`, `ask`, `check` e `--replace` casam por nome exato: codinome que se escreve de duas maneiras é bug esperando acontecer.

Puxar todos os codinomes de **um mesmo universo** ajuda o humano a lembrar quem é quem no canvas — os exemplos aqui usam Star Wars. Escolha o tema que quiser; o que não pode é o nome sugerir hierarquia ou comportamento que o role não dá. Ninguém se chama "Aprendiz" trabalhando com autonomia total.

Registre em `.claude/specs/equipe.md`, junto com os nomes exatos das notas conectadas:

```md
| Codinome | Papel | Preset | Possui | Andar |
|---|---|---|---|---|
| Leia | Arquiteto | <preset capaz> | spec.md, plan.md | 001-login |
| Rey | Engineer | <preset> | src/auth/** | 001-login |
| Finn | Engineer | <preset> | src/ui/** | 001-login |
| Ahsoka | Reviewer | <preset> | — | 001-login |
| Chewie | Git Master | <preset barato> | .git | workspace |
```

## Ordem de montagem

1. **Arquiteto primeiro**, antes de existir contrato. Recrute, conecte, e diga ao usuário o nome exato do terminal para a descoberta começar lá.
2. **Git Master**, enquanto a descoberta corre — não depende do contrato. Nada de repositório começa antes dele existir e antes de todos os roles proibirem git independente.
3. Engineers da onda 1 (fundação), só depois de a spec fechar e você particionar.
4. Reviewer.
5. Engineers das ondas seguintes — só quando a evidência da dependência estiver disponível.

Prefira 3–5 frentes concorrentes e mais ondas, em vez de mais agentes. Respeite a capacidade real do workspace.

O Arquiteto **fica conectado** depois do handoff: ele é quem emenda o contrato quando aparece ambiguidade em `bloqueios.md`. Não dispense no fim da descoberta.

## Contexto por executor

Para cada executor, incluindo o Git Master, crie e conecte duas notas:

- **`spec-<codinome>`** — contrato do executor, que você mantém e ele só lê: objetivo; arquivos e diretórios que possui; paths fora de escopo e seus donos; método e convenções obrigatórias; dependências e ordem de entrega; critério de aceite; evidência de validação exigida; nome exato do Maestro e comando de escalada; nome exato do Git Master e comando de handoff.
- **`tasks-<codinome>`** — checklist mantido pelo executor: cada tarefa com definição de pronto, paths, evidência exigida e dependências.

Todo executor recebe **cinco referências nomeadas** e o role diz quais ele pode editar: `spec.md` da feature, `bloqueios.md`, `decisoes.md`, `spec-<codinome>`, `tasks-<codinome>`. Precisou de uma sexta? Ou o contrato dele está ruim, ou a partição está errada.

**O Arquiteto é a exceção.** Ele não recebe `spec-<codinome>` — ele escreve a spec, não a consome. Briefe com: o pedido do usuário como veio, o caminho onde a feature vai morar (`current/<NNN-slug>/`), seu nome exato para o handoff, e `bloqueios.md` para leitura. O workspace ele investiga sozinho, com o teto de leitura que o role dele já impõe.

## Delegação

Quatro partes, sempre:

- **Objetivo** — o resultado exigido, não uma receita narrada de implementação.
- **Contexto mínimo** — paths relevantes e nomes exatos das notas.
- **Fronteira** — o que ele não pode tocar, e de quem é.
- **Formato de retorno** — a evidência e a estrutura de resposta esperadas.

Delegação em lote só para alvos genuinamente independentes. **Case resultado por nome de agente, nunca por posição no array.** Timeout pelo ritmo da tarefa mais lenta — estourou, veja "Notificação e espera" em `agents/maestro.md`.

## Substituir e dispensar

```bash
maestri recruit "Rey" --preset "<preset novo>" --replace "Rey"  # troca o programa do agente
maestri role assign "Rey" "Engineer-Rey-v2"                     # troca só o papel
```

`--replace` mantém conexões, posição e rotinas — é sempre melhor que dispensar e recrutar de novo — mas **reinicia o processo e perde o histórico de conversa**, por definição do comando. `role assign` não tem esse comportamento documentado: trate como incerto. Nos dois casos, preserve o contexto nas notas antes e mande briefing novo depois.

`maestri dismiss "Nome"` termina o terminal e remove o nó — é remoção, então cai na regra 3 (nada destrutivo sem autorização explícita). Não dispense executor por conta própria só porque a WP fechou: pergunte, ou deixe conectado até o pouso do andar. Nunca delete nota, portal, rotina, role ou terminal para limpeza. Canvas é estado do usuário.
