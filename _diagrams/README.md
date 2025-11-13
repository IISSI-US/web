# Diagrams workspace (not published)

- Put PlantUML sources here (e.g., `diagramas.puml`). Use the canonical path: `_diagrams/mc2mr/diagramas.puml`.
- This folder is prefixed with `_`, so Jekyll will not publish its contents to the site.
- Generated PNGs are written directly to `assets/images/mc2mr/` so pages can use them.

## Regenerate PNGs

Run from repo root:

```bash
bash _scripts/export_mc2mr.sh
```

Requirement:
- Java with `plantuml.jar` at `_scripts/plantuml.jar`

Outputs:
- PNGs written to `assets/images/mc2mr/` (web-visible)
