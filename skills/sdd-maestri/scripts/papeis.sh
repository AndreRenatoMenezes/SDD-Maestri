#!/bin/sh
# Cadastra (ou atualiza) os seis papéis SDD no Maestri, a partir dos moldes da skill.
#
#   sh papeis.sh              cadastra como globais: valem em todo workspace
#   sh papeis.sh --workspace  só neste workspace
#   sh papeis.sh --dry-run    mostra o que faria, sem tocar no Maestri
#
# Roda no terminal do Maestro (os comandos `maestri role` são do Modo Maestro).
# Idempotente: papel que já existe é reescrito com o molde atual. Rode de novo
# depois de atualizar a skill — o caminho dela entra no texto de cada papel.

set -eu

ESCOPO=global
SECO=0
for a in "$@"; do
  case "$a" in
    --workspace) ESCOPO=current ;;
    --global) ESCOPO=global ;;
    --dry-run) SECO=1 ;;
    *) echo "papeis.sh: opção desconhecida: $a" >&2; exit 2 ;;
  esac
done

S=$(cd "$(dirname "$0")/.." && pwd)
M=${MAESTRI_CLI:-maestri}

if [ "$SECO" -eq 0 ] && ! command -v "$M" >/dev/null 2>&1; then
  echo "papeis.sh: CLI maestri não encontrada — rode no terminal do Maestro, dentro do Maestri." >&2
  exit 1
fi

cabecalho() {
  printf '> Papel `%s`, gerado dos moldes da skill sdd-maestri. Arquivos citados abaixo (`SKILL.md`, `agents/…`, `references/…`) ficam em `%s` — `<diretório da skill>` é esse caminho. Leia por ele, mesmo que seu agente não tenha a skill instalada.\n\n' "$1" "$S"
}

cadastrar() {
  nome=$1; shift
  for f in "$@"; do
    [ -f "$S/$f" ] || { echo "papeis.sh: molde ausente: $S/$f" >&2; exit 1; }
  done
  texto=$(cabecalho "$nome"; for f in "$@"; do cat "$S/$f"; printf '\n\n'; done)
  if [ "$SECO" -eq 1 ]; then
    printf '%-20s %5s linhas  ← %s\n' "$nome" "$(printf '%s\n' "$texto" | wc -l | tr -d ' ')" "$*"
    return
  fi
  if "$M" role show "$nome" >/dev/null 2>&1; then
    "$M" role write "$nome" "$texto" >/dev/null
    echo "atualizado  $nome"
  else
    "$M" role create "$nome" "$texto" --scope "$ESCOPO" >/dev/null
    echo "criado      $nome ($ESCOPO)"
  fi
}

cadastrar "SDD Maestro"         agents/maestro.md
cadastrar "SDD Maestro Reserva" agents/maestro-reserva.md
cadastrar "SDD Arquiteto"       agents/arquiteto.md references/descoberta.md
cadastrar "SDD Engineer"        agents/engineer.md
cadastrar "SDD Reviewer"        agents/reviewer.md
cadastrar "SDD Git Master"      agents/git-master.md

[ "$SECO" -eq 1 ] || echo "Pronto. Papéis em uso reiniciam o agente só quando reatribuídos (role assign); o texto novo vale no próximo início."
