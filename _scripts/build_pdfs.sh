#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NOTICE="> [Versión PDF disponible](./index.pdf)"
TARGET_DIRS=("laboratorios" "mc2mr" "req2sql")

has_pdf_flag() {
  local file="$1"
  head -n 40 "$file" | grep -Eiq '^pdf_version:[[:space:]]*"?true' 
}

ensure_notice() {
  local file="$1"
  if grep -Fqx "$NOTICE" "$file"; then
    return
  fi
  local tmp
  tmp="$(mktemp)"
  awk -v notice="$NOTICE" '
    BEGIN { in = 0; inserted = 0 }
    NR == 1 && $0 == "---" { in = 1; print; next }
    in && $0 == "---" {
      print
      if (!inserted) {
        print ""
        print notice
        print ""
        inserted = 1
      }
      in = 0
      next
    }
    { print }
    END {
      if (!inserted) {
        print ""
        print notice
      }
    }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"
}

compile_pdf() {
  local md="$1"
  local rel="${md#$ROOT/}"
  local pdf_rel="${rel%.md}.pdf"
  (cd "$ROOT" && typst compile md2pdf.typ "$pdf_rel" --input "md=$rel")
}

discover_indexes() {
  local files=()
  local dir
  for dir in "${TARGET_DIRS[@]}"; do
    if [[ -d "$ROOT/$dir" ]]; then
      while IFS= read -r -d '' file; do
        if has_pdf_flag "$file"; then
          files+=("$file")
        fi
      done < <(find "$ROOT/$dir" -type f -name "index.md" -print0)
    fi
  done
  printf "%s\n" "${files[@]}"
}

main() {
  mapfile -t indexes < <(discover_indexes)
  if [[ "${#indexes[@]}" -eq 0 ]]; then
    echo "No se han encontrado índices con pdf_version: true" >&2
    exit 0
  fi
  local md rel
  for md in "${indexes[@]}"; do
    rel="${md#$ROOT/}"
    ensure_notice "$md"
    echo "[PDF] Generando $rel"
    compile_pdf "$md"
  done
}

main "$@"
