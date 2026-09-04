#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=plantuml-lib.sh
source "${REPO_DIR}/_scripts/plantuml-lib.sh"

PUBLIC_OUT_DIR="${REPO_DIR}/assets/images/iissi1/laboratorios/fig/req"  # tracked; published

# Canonical diagram source location
DIAGRAMS_DIR="${REPO_DIR}/_diagrams/grades"
SRC_PUML="${DIAGRAMS_DIR}/diagrams.puml"

if [[ ! -f "${SRC_PUML}" ]]; then
  echo "[ERR] PlantUML source not found: ${SRC_PUML}" >&2
  echo "      Expected at: _diagrams/grades/diagrams.puml" >&2
  exit 1
fi

check_plantuml_jar
mkdir -p "${PUBLIC_OUT_DIR}"

render_with_jar() {
  echo "[INFO] Rendering grades diagrams with Java + PlantUML jar..."
  (
    cd "${DIAGRAMS_DIR}"
    # Output directly to public assets dir (avoids intermediate copy)
    java -jar "${PLANTUML_JAR}" -tsvg -o "${PUBLIC_OUT_DIR}" "diagrams.puml"
  )
  
  # Rename the generated files to match the expected names
  if [[ -f "${PUBLIC_OUT_DIR}/grados-dc-jerarquia.svg" ]]; then
    mv "${PUBLIC_OUT_DIR}/grados-dc-jerarquia.svg" "${PUBLIC_OUT_DIR}/d_jerarquia.svg"
  fi
  if [[ -f "${PUBLIC_OUT_DIR}/grados-dc-academico.svg" ]]; then
    mv "${PUBLIC_OUT_DIR}/grados-dc-academico.svg" "${PUBLIC_OUT_DIR}/d_academico.svg"
  fi
  if [[ -f "${PUBLIC_OUT_DIR}/grados-dc-alumnos.svg" ]]; then
    mv "${PUBLIC_OUT_DIR}/grados-dc-alumnos.svg" "${PUBLIC_OUT_DIR}/d_alumnos.svg"
  fi
  if [[ -f "${PUBLIC_OUT_DIR}/grados-enum.svg" ]]; then
    mv "${PUBLIC_OUT_DIR}/grados-enum.svg" "${PUBLIC_OUT_DIR}/d_enum.svg"
  fi
}

render_with_jar

# Report
GEN_COUNT=$(ls -1 "${PUBLIC_OUT_DIR}"/*.svg 2>/dev/null | wc -l | tr -d ' ')
if [[ ${GEN_COUNT} -eq 0 ]]; then
  echo "[WARN] No SVGs were generated from ${SRC_PUML}." >&2
else
  echo "[DONE] SVGs are up to date in assets/images/iissi1/laboratorios/fig/req/ (${GEN_COUNT} files)"
fi
