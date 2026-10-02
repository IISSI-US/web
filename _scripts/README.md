# Project scripts (not published)

This folder contains helper scripts and tools for maintaining the site.

- This folder starts with `_`, so Jekyll won't publish it (not accessible over the web).
- Put PlantUML jar at `_scripts/plantuml.jar`.

Available scripts:
- `export_exercise.sh usuarios`: Render migrated Usuarios diagrams with the shared style to SVG under `assets/images/iissi1/req2sql/usuarios/`.
- Database loaders and test runners live in `_code/`; see `_code/README.md`.
- `export_mc2mr.sh`: Render PlantUML sources to PNG directly into `assets/images/mc2mr/`.
- `export_req2sql.sh`: Render all PlantUML sources under `_diagrams/req2sql/` to PNGs under `assets/images/req2sql/` (mirrors subfolders).

Usage:

```bash
bash _scripts/export_mc2mr.sh
```

```bash
bash _scripts/export_req2sql.sh
```

Renderer:
1. `java -jar _scripts/plantuml.jar`
