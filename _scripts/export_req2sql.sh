#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Ejercicios publicados, con fuentes unificadas y estilo final.iuml.
exec bash "$ROOT/_scripts/export_exercise.sh" all
