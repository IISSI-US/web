#!/usr/bin/env python3
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET_DIRS = ("iissi1", "iissi2")
NOTICE = "> [Versión PDF disponible](./index.pdf)\n"


def parse_front_matter(text: str):
    if not text.startswith("---\n"):
        return {}, text
    lines = text.splitlines()
    closing = None
    for idx in range(1, len(lines)):
        if lines[idx].strip() == "---":
            closing = idx
            break
    if closing is None:
        return {}, text
    meta_lines = lines[1:closing]
    body = "\n".join(lines[closing + 1 :]).lstrip("\n")
    meta = {}
    for line in meta_lines:
        if not line or line.strip().startswith("#") or ":" not in line:
            continue
        key, value = line.split(":", 1)
        meta[key.strip()] = value.strip().strip('"\'').lower()
    return meta, body


def has_pdf_version(path: Path):
    text = path.read_text(encoding="utf-8")
    meta, _ = parse_front_matter(text)
    return meta.get("pdf_version") == "true"


def ensure_notice(path: Path):
    text = path.read_text(encoding="utf-8")
    if NOTICE.strip() in text or not text.startswith("---\n"):
        return
    closing_idx = text.find("\n---", 3)
    if closing_idx == -1:
        return
    after_closing = text.find("\n", closing_idx + 1)
    if after_closing == -1:
        after_closing = len(text)
    insert_pos = after_closing + 1
    updated = text[:insert_pos] + NOTICE + "\n" + text[insert_pos:]
    path.write_text(updated, encoding="utf-8")


def needs_rebuild(md_path: Path) -> bool:
    """Check if PDF needs to be rebuilt (doesn't exist or MD is newer)."""
    pdf_path = md_path.with_suffix(".pdf")
    if not pdf_path.exists():
        return True
    return md_path.stat().st_mtime > pdf_path.stat().st_mtime


def build_pdf(md_path: Path, force: bool = False):
    pdf_path = md_path.with_suffix(".pdf")
    
    # Skip if PDF is up-to-date and not forcing
    if not force and not needs_rebuild(md_path):
        return False
    
    md_rel = md_path.relative_to(ROOT)
    pdf_rel = pdf_path.relative_to(ROOT)
    subprocess.run(
        ["typst", "compile", "md2pdf.typ", str(pdf_rel), "--input", f"md={md_rel}"],
        check=True,
        cwd=ROOT,
    )
    return True


def discover_indexes():
    for base in TARGET_DIRS:
        base_path = ROOT / base
        if not base_path.exists():
            continue
        for md in base_path.rglob("index.md"):
            if has_pdf_version(md):
                yield md


def main():
    parser = argparse.ArgumentParser(
        description="Genera PDFs de los archivos index.md con pdf_version: true"
    )
    parser.add_argument(
        "--incremental",
        "-i",
        action="store_true",
        help="Solo regenerar PDFs si el MD es más reciente que el PDF",
    )
    args = parser.parse_args()
    
    indexes = list(discover_indexes())
    if not indexes:
        print("No se han encontrado índices con pdf_version: true", file=sys.stderr)
        return
    
    total = 0
    skipped = 0
    
    for md in indexes:
        ensure_notice(md)
        
        # En modo incremental, verificar si es necesario regenerar
        if args.incremental and not needs_rebuild(md):
            skipped += 1
            continue
            
        print(f"[PDF] Generando {md.relative_to(ROOT)}")
        if build_pdf(md, force=not args.incremental):
            total += 1
    
    # Mostrar resumen
    if args.incremental:
        print(f"\n[PDF] Generados: {total}, Omitidos (actualizados): {skipped}")
    else:
        print(f"\n[PDF] Total generados: {total}")


if __name__ == "__main__":
    main()
