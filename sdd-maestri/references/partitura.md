# Partitura como blueprint

Partituras são JSON em `~/.maestri/partituras/` que capturam layout espacial, roles, conexões, URLs de portais e comandos de inicialização. Caminhos absolutos são omitidos, então uma partitura feita no macOS roda no Windows.

Por serem texto, **versionam no git**. É infraestrutura como código para time agêntico.

## O que virar partitura

Depois que um time SDD funcionou bem, salve o arranjo: Maestro + N Engineers + Reviewer + Git Master, com as notas (`bloqueios`, `decisoes`, specs de executor, painel) já conectadas e posicionadas.

Isso mata o custo de montagem toda vez que uma feature nova começa. O que muda entre features é o conteúdo das specs — não a topologia do time.

## Blueprints que valem a pena manter

| Partitura | Composição | Quando |
|---|---|---|
| `sdd-solo` | Maestro + 1 Engineer + Git Master | feature pequena, uma fronteira só |
| `sdd-padrao` | Maestro + 2–3 Engineers + Reviewer + Git Master | o caso comum |
| `sdd-fundacao` | Maestro + Engineer capaz + Reviewer capaz + Git Master | schema, auth, contrato entre camadas |
| `sdd-correcao` | Maestro + 1 Engineer + Reviewer | onda de correção depois de gate reprovado |

Nomes são sugestão. O que importa é ter poucos arranjos conhecidos em vez de improvisar a topologia a cada feature.

## Regras

1. **Preset é referência, não modelo hardcoded.** Se a partitura fixa um modelo específico, ela envelhece em semanas. Use preset descoberto no `preset list`.
2. **Role de projeto fica com escopo de workspace.** Só torne global o que for genuinamente reutilizável entre projetos — o role do Git Master costuma ser o único.
3. **Um andar por feature.** A partitura define o arranjo dentro do andar; `maestri floor create` isola a frente de trabalho e o branch correspondente.
4. **Não versione segredo.** Partitura é texto que vai para o repositório: comando de inicialização com token dentro é vazamento.

## Andares e pouso

Andar = isolamento de contexto. Ground floor para o estado estável; andar novo para cada feature em `current/`.

O "pouso" do andar acontece quando **todas as WPs estão em `pronto`**:

1. Git Master prepara o PR e manda título e descrição para o Maestro.
2. Maestro apresenta ao usuário e **espera autorização explícita**.
3. Autorizado: merge, e só então arquive a feature (`archive/<dominio>/`) e encerre o andar.

Feature parcial não arquiva. Termine ou cancele explicitamente — cancelada também vai para o archive, com o motivo registrado.
