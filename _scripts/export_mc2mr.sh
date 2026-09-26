#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=plantuml-lib.sh
source "${REPO_DIR}/_scripts/plantuml-lib.sh"

PUBLIC_OUT_DIR="${REPO_DIR}/assets/images/iissi1/mc2mr"  # tracked; published

# Canonical diagram source location (simplified)
DIAGRAMS_DIR="${REPO_DIR}/_diagrams/mc2mr"
SRC_PUML="${DIAGRAMS_DIR}/diagramas.puml"

# Check if at least one .puml file exists
if ! compgen -G "${DIAGRAMS_DIR}/*.puml" > /dev/null; then
  echo "[ERR] No PlantUML source files found in: ${DIAGRAMS_DIR}" >&2
  echo "      Expected .puml files in: _diagrams/mc2mr/" >&2
  exit 1
fi

check_plantuml_jar
mkdir -p "${PUBLIC_OUT_DIR}"

render_with_jar() {
  echo "[INFO] Rendering with Java + PlantUML jar..."
  (
    cd "${DIAGRAMS_DIR}"
    # Output directly to public assets dir (avoids intermediate copy)
    for puml_file in *.puml; do
      echo "[INFO] Processing ${puml_file}..."
      java -jar "${PLANTUML_JAR}" -tpng -o "${PUBLIC_OUT_DIR}" "${puml_file}"
    done
  )
}

render_with_jar

# Report
GEN_COUNT=$(ls -1 "${PUBLIC_OUT_DIR}"/*.png 2>/dev/null | wc -l | tr -d ' ')
if [[ ${GEN_COUNT} -eq 0 ]]; then
  echo "[WARN] No PNGs were generated from .puml files in ${DIAGRAMS_DIR}." >&2
else
  echo "[DONE] PNGs are up to date in assets/images/iissi1/mc2mr/ (${GEN_COUNT} files)"
fi
