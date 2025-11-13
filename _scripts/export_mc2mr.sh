#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_OUT_DIR="${REPO_DIR}/assets/images/mc2mr"  # tracked; published

# Canonical diagram source location (simplified)
DIAGRAMS_DIR="${REPO_DIR}/_diagrams/mc2mr"
SRC_PUML="${DIAGRAMS_DIR}/diagramas.puml"
PLANTUML_JAR="${REPO_DIR}/_scripts/plantuml.jar"

if [[ ! -f "${SRC_PUML}" ]]; then
  echo "[ERR] PlantUML source not found: ${SRC_PUML}" >&2
  echo "      Expected at: _diagrams/mc2mr/diagramas.puml" >&2
  exit 1
fi

mkdir -p "${PUBLIC_OUT_DIR}"

render_with_jar() {
  echo "[INFO] Rendering with Java + PlantUML jar..."
  (
    cd "${DIAGRAMS_DIR}"
    # Output directly to public assets dir (avoids intermediate copy)
    java -jar "${PLANTUML_JAR}" -tpng -o "${PUBLIC_OUT_DIR}" "diagramas.puml"
  )
}

# Choose renderer (strict: only local jar)
if [[ -f "${PLANTUML_JAR}" ]]; then
  render_with_jar
else
  echo "[ERR] PlantUML jar not found: ${PLANTUML_JAR}" >&2
  echo "      Place the renderer at: _scripts/plantuml.jar" >&2
  exit 2
fi

# Report
GEN_COUNT=$(ls -1 "${PUBLIC_OUT_DIR}"/*.png 2>/dev/null | wc -l | tr -d ' ')
if [[ ${GEN_COUNT} -eq 0 ]]; then
  echo "[WARN] No PNGs were generated from ${SRC_PUML}." >&2
else
  echo "[DONE] PNGs are up to date in assets/images/mc2mr/ (${GEN_COUNT} files)"
fi
