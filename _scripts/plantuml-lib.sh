#!/usr/bin/env bash
# Shared PlantUML helpers – source this file; do NOT execute it directly.
# Requires: REPO_DIR to be set by the calling script.

PLANTUML_JAR="${REPO_DIR}/_scripts/plantuml.jar"

# Exit with an error if the PlantUML jar is missing.
check_plantuml_jar() {
  if [[ ! -f "${PLANTUML_JAR}" ]]; then
    echo "[ERR] PlantUML jar not found: ${PLANTUML_JAR}" >&2
    echo "      Place the renderer at: _scripts/plantuml.jar" >&2
    exit 2
  fi
}
