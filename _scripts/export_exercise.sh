#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
case "${1:-}" in
  usuarios|aficiones-est|aficiones-din|pedidos|empleados|apartamentos) project="$1" ;;
  *) echo "Uso: bash _scripts/export_exercise.sh <proyecto>" >&2; exit 2 ;;
esac
output_dir="$ROOT/assets/images/iissi1/req2sql/$project"
mkdir -p "$output_dir"
java -jar "$ROOT/_scripts/plantuml.jar" -failfast2 -charset UTF-8 -tsvg \
  -o "$output_dir" "$ROOT/_diagrams/$project/diagrams.puml"
