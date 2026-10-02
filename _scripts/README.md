# Project scripts (not published)

This folder contains helper scripts and tools for maintaining the site.

- This folder starts with `_`, so Jekyll won't publish it (not accessible over the web).
- Put PlantUML jar at `_scripts/plantuml.jar`.

Available scripts:
- `export_exercise.sh <proyecto|all>`: Render migrated exercise diagrams with the shared style to PNG under `assets/images/iissi1/req2sql/<proyecto>/`.
- Database loaders and test runners live in `_code/`; see `_code/README.md`.
- `export_mc2mr.sh`: Render PlantUML sources to PNG directly into `assets/images/mc2mr/`.
- `export_req2sql.sh`: Render the nine published Req→SQL exercises (ten SQL projects); delegates to `export_exercise.sh all`. Legacy `_diagrams/req2sql/` sources are not used by this exporter.

Usage:

```bash
bash _scripts/export_mc2mr.sh
```

```bash
bash _scripts/export_req2sql.sh
```

Renderer:
1. `java -jar _scripts/plantuml.jar`
