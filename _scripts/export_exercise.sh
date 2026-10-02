#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECTS=(usuarios aficiones-est aficiones-din pedidos empleados apartamentos animales proyectos espectaculos bodegas)

if [[ "${1:-}" == "all" && "$#" == 1 ]]; then
  selected=("${PROJECTS[@]}")
elif [[ "$#" == 1 && " ${PROJECTS[*]} " == *" $1 "* ]]; then
  selected=("$1")
else
  echo "Uso: bash _scripts/export_exercise.sh <proyecto|all>" >&2
  echo "Proyectos: ${PROJECTS[*]}" >&2
  exit 2
fi

for project in "${selected[@]}"; do
  output_dir="$ROOT/assets/images/iissi1/req2sql/$project"
  mkdir -p "$output_dir"
  java -jar "$ROOT/_scripts/plantuml.jar" -failfast2 -charset UTF-8 -tpng \
    -o "$output_dir" "$ROOT/_diagrams/$project/diagrams.puml"
done
