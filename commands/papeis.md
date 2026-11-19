---
description: Cadastra (ou atualiza) os seis papéis SDD no Maestri — Maestro, Maestro Reserva, Arquiteto, Engineer, Reviewer e Git Master
argument-hint: "[--workspace] [--dry-run]"
---

Cadastre os papéis SDD no Maestri a partir dos moldes da skill sdd-maestri.

1. Rode, neste terminal (precisa ser o terminal do Maestro, em Modo Maestro):

   ```bash
   sh "${CLAUDE_PLUGIN_ROOT}/skills/sdd-maestri/scripts/papeis.sh" $ARGUMENTS
   ```

   Sem argumento, os papéis ficam **globais**: valem em todo workspace, e projeto novo já começa com eles. `--workspace` restringe a este workspace; `--dry-run` só mostra o que faria. Falhou com "This terminal is not the Maestro": peça ao usuário para ligar o Modo Maestro aqui e pare.

2. Confira com `maestri role list` que os seis aparecem.

3. Diga ao usuário, em poucas linhas:
   - quais papéis foram criados e quais atualizados, e o escopo;
   - que o terminal do Maestro ainda não tem papel: para o protocolo do Maestro sobreviver a compactação de contexto e reinício, ele atribui **`SDD Maestro`** ao terminal do Maestro pelo app (na interface em português, papel aparece como "responsabilidade"). Isso reinicia o agente — faça entre features, nunca no meio de uma onda;
   - que papel em uso por um agente só muda o comportamento dele no próximo início, e que depois de atualizar o plugin vale rodar `/sdd-maestri:papeis` de novo, porque o caminho da skill vai no texto de cada papel.

Não atribua papel a nenhum terminal, não recrute e não apague papel: este comando só cadastra.
