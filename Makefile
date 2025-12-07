# Simple Makefile for image exports and related tooling

.PHONY: help mc2mr-images req2sql-images images pdfs clean-images clean-mc2mr-images clean-req2sql-images build_site serve_site

.POSIX:

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "  help              Mostrar esta ayuda."
	@echo "  mc2mr-images      Renderiza los diagramas de la colección MC→MR."
	@echo "  req2sql-images    Renderiza los diagramas de la colección Req→SQL."
	@echo "  images            Renderiza todos los diagramas (alias de las dos anteriores)."
	@echo "  pdfs              Genera los PDF de cada index.md con pdf_version: true."
	@echo "  build_site        Construye el sitio web estático."
	@echo "  serve_site        Lanza un servidor de desarrollo con livereload."
	@echo "  clean-mc2mr-images   Elimina los PNG generados para MC→MR."
	@echo "  clean-req2sql-images Elimina los PNG generados para Req→SQL."
	@echo "  clean-images         Ejecuta ambos clean."

# Render PlantUML diagrams and update public PNGs for MC2MR
mc2mr-images:
	bash _scripts/export_mc2mr.sh

# Render PlantUML diagrams and update public PNGs for Req→MC→MR→SQL
req2sql-images:
	bash _scripts/export_req2sql.sh

# Alias to render all images
images: mc2mr-images req2sql-images

# Generate PDF versions from markdown indexes (requires pdf_version: true)
pdfs:
	python3 _scripts/build_pdfs.py

# Remove generated PNGs from public assets
clean-mc2mr-images:
	rm -f assets/images/mc2mr/*.png || true

clean-req2sql-images:
	rm -f assets/images/req2sql/**/*.png assets/images/req2sql/*.png 2>/dev/null || true

clean-images: clean-mc2mr-images clean-req2sql-images

# Build the static website
build_site:
	bundle exec jekyll build

# Serve the website with livereload
serve_site:
	bundle exec jekyll serve --livereload
