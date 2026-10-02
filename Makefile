# Build and run the Jekyll site locally.

.PHONY: help build build-prod serve serve-prod serve-dev pdfs pdfs-incremental

.POSIX:

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "=== Desarrollo local ==="
	@echo "  serve-dev         Servidor local en raíz / (recomendado para desarrollo)"
	@echo "  serve-prod        Servidor local en /web (prueba antes de push)"
	@echo "  serve             Servidor con baseurl de producción (= serve-prod)"
	@echo ""
	@echo "=== Construcción ==="
	@echo "  build             Construye el sitio web estático"
	@echo "  build-prod        Build con JEKYLL_ENV=production y baseurl correcto"
	@echo ""
	@echo "=== PDFs ==="
	@echo "  pdfs              Genera todos los PDF de index.md con pdf_version: true"
	@echo "  pdfs-incremental  Regenera solo PDFs cuyo MD sea más reciente"
	@echo ""
	@echo "=== Ayuda ==="
	@echo "  help              Mostrar esta ayuda"

# Build the static website
build:
	bundle exec jekyll build

# Serve con baseurl de producción (alias de serve-prod)
serve:
	bundle exec jekyll serve --livereload --baseurl "/web"

# Build con JEKYLL_ENV=production y baseurl de producción
build-prod:
	JEKYLL_ENV=production bundle exec jekyll build --baseurl "/web"

# Serve local simulando GitHub Pages (baseurl = /web)
# Útil para probar rutas antes de push
serve-prod:
	bundle exec jekyll serve --livereload --baseurl "/web"

# Serve en raíz / (sin baseurl) - RECOMENDADO para desarrollo
# Usa _config.dev.yml que sobrescribe url y baseurl
serve-dev:
	bundle exec jekyll serve --livereload --config _config.yml,_config.dev.yml

# Generate PDF versions from markdown indexes (requires pdf_version: true)
pdfs:
	python3 _scripts/build_pdfs.py

# Generate PDFs only for modified markdown files (incremental build)
pdfs-incremental:
	python3 _scripts/build_pdfs.py --incremental
