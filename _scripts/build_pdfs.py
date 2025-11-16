#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET_DIRS = ("laboratorios", "mc2mr", "req2sql")
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


def build_pdf(md_path: Path):
    pdf_path = md_path.with_suffix(".pdf")
    md_rel = md_path.relative_to(ROOT)
    pdf_rel = pdf_path.relative_to(ROOT)
    subprocess.run(
        ["typst", "compile", "md2pdf.typ", str(pdf_rel), "--input", f"md={md_rel}"],
        check=True,
        cwd=ROOT,
    )


def discover_indexes():
    for base in TARGET_DIRS:
        base_path = ROOT / base
        if not base_path.exists():
            continue
        for md in base_path.rglob("index.md"):
            if has_pdf_version(md):
                yield md


def main():
    indexes = list(discover_indexes())
    if not indexes:
        print("No se han encontrado índices con pdf_version: true", file=sys.stderr)
        return
    for md in indexes:
        ensure_notice(md)
        print(f"[PDF] Generando {md.relative_to(ROOT)}")
        build_pdf(md)


if __name__ == "__main__":
    main()
