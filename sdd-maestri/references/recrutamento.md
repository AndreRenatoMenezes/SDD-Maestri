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

Criar o role a partir do arquivo em `agents/<papel>.md` (preencha `<...>` antes):

```bash
maestri role create "Engineer-Bruma" "$(cat agents/engineer.md)"
```

Recrutar já com preset e role certos — vem automaticamente conectado a você:

```bash
maestri recruit "Bruma" --preset "<preset>" --role "Engineer-Bruma"
```

Conectar as notas de contrato (`spec-<codinome>`, `tasks-<codinome>`) ao recruta — `connect` casa por nome exato, do jeito que `maestri list` imprime:

```bash
maestri connect "Bruma" "spec-Bruma"
maestri connect "Bruma" "tasks-Bruma"
```

## Seleção por impacto de falha

| Tipo de trabalho | Preset |
|---|---|
| fundação, segurança, modelo de dados, regra de negócio, contrato entre camadas, mudança de raio grande | o mais capaz disponível |
| trabalho mecânico e delimitado | um mais rápido |
| git, commit, PR | o mais barato |
| revisão de trabalho crítico | capaz — e **diferente** do preset que implementou |

Quando um resultado errado causaria retrabalho do time inteiro, prefira confiabilidade a velocidade.

## Codinomes

Curtos e distintivos. **O role descreve o trabalho; o codinome dá identidade.** Nada de "Engineer 1", "Engineer 2" — vira confusão de handoff. Use nomes que você consiga digitar rápido em `maestri ask` e `maestri check`.

Registre em `.claude/specs/equipe.md`:

```md
| Codinome | Papel | Preset | Possui | Andar |
|---|---|---|---|---|
| Bruma | Engineer | <preset> | src/auth/** | 001-login |
| Serra | Engineer | <preset> | src/ui/** | 001-login |
| Farol | Reviewer | <preset> | — | 001-login |
| Âncora | Git Master | <preset barato> | .git | workspace |
```

Nomes exatos das notas conectadas também vão aqui. Briefing sempre cita o nome exato.

## Ordem de montagem

1. **Git Master primeiro.** Nada de repositório começa antes dele existir e antes de todos os roles proibirem git independente.
2. Engineers da onda 1 (fundação).
3. Reviewer.
4. Engineers das ondas seguintes — só quando a evidência da dependência estiver disponível.

Prefira 3–5 frentes concorrentes e mais ondas, em vez de mais agentes. Respeite a capacidade real do workspace.

## Contexto por executor

Para cada executor, incluindo o Git Master, crie e conecte:

- `spec-<codinome>` — contrato do executor. Você é o dono; ele só lê.
- `tasks-<codinome>` — checklist mantido pelo executor, com definição de pronto por tarefa.

`spec-<codinome>` contém: objetivo; arquivos e diretórios que possui; paths fora de escopo e seus donos; método e convenções obrigatórias; dependências e ordem de entrega; critério de aceite; evidência de validação exigida; nome exato do Maestro e comando de escalada; nome exato do Git Master e comando de handoff.

`tasks-<codinome>` contém tarefas em checklist, cada uma com sua definição de pronto, paths, evidência exigida e dependências.

Todo executor recebe **cinco referências nomeadas** e o role diz quais ele pode editar:

1. `spec.md` da feature
2. `bloqueios.md`
3. `decisoes.md`
4. `spec-<codinome>`
5. `tasks-<codinome>`

## Delegação

Toda mensagem de delegação tem quatro partes:

- **Objetivo** — o resultado exigido, não uma receita narrada de implementação.
- **Contexto mínimo** — paths relevantes e nomes exatos das notas.
- **Fronteira** — o que ele não pode tocar, e de quem é.
- **Formato de retorno** — a evidência e a estrutura de resposta esperadas.

Delegação em lote só para alvos genuinamente independentes. **Case resultado por nome de agente, nunca por posição no array.**

Timeout pelo ritmo da tarefa mais lenta. Estourou? **Não reenvie.** Use:

```bash
maestri check "Nome do Agente"
```

Progresso visível: espere mais. Intervenha só quando o agente está comprovadamente travado.

Resultado longo: instrua o executor a responder com `maestri ask` endereçado a você, senão trunca.

## Substituir agente

Trocar o programa do agente:

```bash
maestri recruit "Bruma" --preset "<preset novo>" --replace "Bruma"
```

`--replace` mantém conexões, posição e rotinas no lugar — é sempre melhor que dispensar e recrutar de novo.

Trocar só o papel, mantendo o mesmo agente:

```bash
maestri role assign "Bruma" "Engineer-Bruma-v2"
```

`--replace` **reinicia o processo e perde o histórico de conversa**, por definição do próprio comando. `role assign` não tem esse comportamento documentado — trate como incerto e preserve o contexto nas notas antes de qualquer uma das duas, mandando briefing novo depois.

## Fim de ciclo

`maestri dismiss "Nome"` para terminal e remove o nó — é remoção de terminal, então cai na regra 3 (nada destrutivo sem autorização explícita do usuário). Não dispense executor por conta própria só porque a WP fechou; pergunte, ou deixe conectado até o pouso do andar.

Nunca delete nota, portal, rotina, role ou terminal para limpeza. Canvas é estado do usuário.
