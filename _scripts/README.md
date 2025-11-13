# Project scripts (not published)

This folder contains helper scripts and tools for maintaining the site.

- This folder starts with `_`, so Jekyll won't publish it (not accessible over the web).
- Put PlantUML jar at `_scripts/plantuml.jar`.

Available scripts:
- `export_mc2mr.sh`: Render PlantUML sources to PNG directly into `assets/images/mc2mr/`.

Usage:

```bash
bash _scripts/export_mc2mr.sh
```

Renderer:
1. `java -jar _scripts/plantuml.jar`
