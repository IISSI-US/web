#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_BASE="${REPO_DIR}/_diagrams/req2sql"
OUT_BASE="${REPO_DIR}/assets/images/iissi1/req2sql"  # tracked; published
PLANTUML_JAR="${REPO_DIR}/_scripts/plantuml.jar"

if [[ ! -d "${SRC_BASE}" ]]; then
  echo "[ERR] Source dir not found: ${SRC_BASE}" >&2
  exit 1
fi

if [[ ! -f "${PLANTUML_JAR}" ]]; then
  echo "[ERR] PlantUML jar not found: ${PLANTUML_JAR}" >&2
  echo "      Place the renderer at: _scripts/plantuml.jar" >&2
  exit 2
fi

mkdir -p "${OUT_BASE}"

render_dir() {
  local src_dir="$1"
  local rel
  rel="${src_dir#"${SRC_BASE}/"}"
  # If src_dir is the base, rel stays the same
  if [[ "${src_dir}" == "${SRC_BASE}" ]]; then
    rel=""
  fi
  local out_dir="${OUT_BASE}"
  if [[ -n "${rel}" ]]; then
    out_dir="${OUT_BASE}/${rel}"
  fi
  mkdir -p "${out_dir}"
  (
    cd "${src_dir}"
    # Render all .puml files in this directory
    shopt -s nullglob
    local files=( *.puml )
    if (( ${#files[@]} > 0 )); then
      echo "[INFO] Rendering $(printf '%s ' "${files[@]}") -> ${out_dir}"
      java -jar "${PLANTUML_JAR}" -tpng -o "${out_dir}" "${files[@]}"
    fi
  )
}

# Render top-level .puml files if any
render_dir "${SRC_BASE}"

# Render each immediate subdirectory; include nested trees as well
while IFS= read -r -d '' dir; do
  render_dir "${dir}"
done < <(find "${SRC_BASE}" -mindepth 1 -type d -print0)

# Report
GEN_COUNT=$(find "${OUT_BASE}" -type f -name '*.png' | wc -l | tr -d ' ')
if [[ ${GEN_COUNT} -eq 0 ]]; then
  echo "[WARN] No PNGs were generated from ${SRC_BASE}." >&2
else
  echo "[DONE] PNGs are up to date in assets/images/iissi1/req2sql/ (${GEN_COUNT} files)"
fi
