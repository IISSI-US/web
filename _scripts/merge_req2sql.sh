#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="${REPO_DIR}/req2sql"

strip_front_matter(){
  awk 'BEGIN{fm=0}
       NR==1 && $0 ~ /^---\s*$/ {fm=1; next}
       fm==1 && $0 ~ /^---\s*$/ {fm=2; next}
       fm<2 {next}
       {print}' "$1"
}

get_yaml_value(){
  local file="$1" key="$2"
  awk -v key="$2" '
    BEGIN{fm=0}
    $0 ~ /^---[[:space:]]*$/ {fm++; next}
    (fm==1) && $0 ~ ("^" key "[[:space:]]*:") {
      val=$0;
      sub("^[[:space:]]*" key "[[:space:]]*:[[:space:]]*", "", val);
  # Guard against accidental duplicated prefix like title: title: X
      while (val ~ ("^" key "[[:space:]]*:")) {
        sub("^[[:space:]]*" key "[[:space:]]*:[[:space:]]*", "", val);
      }
      gsub(/^"|"$/, "", val);
      print val; exit
    }
  ' "$file"
}

ensure_published_false(){
  local file="$1"
  # if already has published: false, skip
  if grep -q "^published:\s*false\s*$" "$file"; then return 0; fi
  # insert after the first line of front matter
  awk 'NR==1{print; getline; print; print "published: false"; next} {print}' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

process_exercise(){
  local dir="$1"
  local idx="${dir}/index.md"
  [[ -f "$idx" ]] || return 0
  local title
  title=$(get_yaml_value "$idx" "title")
  if [[ -z "${title}" ]]; then
    title="$(basename "$dir" | sed 's/^\d\+_//')"
  fi

  # collect section files (excluding index.md)
  mapfile -t files < <(find "$dir" -maxdepth 1 -type f -name '*.md' ! -name 'index.md')
  if (( ${#files[@]} == 0 )); then
    echo "[INFO] No section files in $(basename "$dir"), skipping merge"
    return 0
  fi

  # sort by nav_order (numeric), fallback to name
  declare -A orders
  for f in "${files[@]}"; do
    nav=$(get_yaml_value "$f" "nav_order" || true)
    if [[ -z "${nav:-}" ]]; then nav=9999; fi
    orders["$f"]="$nav"
  done
  IFS=$'\n' read -r -d '' -a sorted < <(printf '%s\n' "${files[@]}" | awk -vOFS='\t' -vFS='\t' '{print $0}' | sort -t $'\t' -k1,1 | while read -r path; do echo -e "${orders[$path]}\t$path"; done | sort -n -k1,1 | cut -f2- && printf '\0')

  local tmp="${dir}/.index.merge.tmp"
  {
    printf "---\n"
    printf "title: %s\n" "$title"
    printf "layout: single\n"
    printf "sidebar:\n  nav: req2sql\n"
    printf "toc: true\n"
    printf "---\n\n"
    printf "# %s\n\n" "$title"
  } > "$tmp"

  for f in "${sorted[@]}"; do
    sec_title=$(get_yaml_value "$f" "title")
    [[ -n "$sec_title" ]] || sec_title="$(basename "$f" .md)"
    printf "\n## %s\n\n" "$sec_title" >> "$tmp"
    strip_front_matter "$f" >> "$tmp"
    ensure_published_false "$f"
  done

  # backup old index and replace
  cp "$idx" "${idx}.bak"
  mv "$tmp" "$idx"
  echo "[MERGED] $(basename "$dir"): $((${#files[@]})) secciones en index.md"
}

main(){
  shopt -s nullglob
  for dir in "${BASE_DIR}"/*; do
    [[ -d "$dir" ]] || continue
    process_exercise "$dir"
  done
}

main "$@"
