# Simple Makefile for image exports and related tooling

.PHONY: help mc2mr-images req2sql-images grades-images images pdfs clean-images clean-mc2mr-images clean-req2sql-images clean-grades-images build_site serve_site

.POSIX:

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "  help              Mostrar esta ayuda."
	@echo "  mc2mr-images      Renderiza los diagramas de la colección MC→MR."
	@echo "  req2sql-images    Renderiza los diagramas de la colección Req→SQL."
	@echo "  grades-images     Renderiza los diagramas de requisitos (grades)."
	@echo "  images            Renderiza todos los diagramas."
	@echo "  pdfs              Genera los PDF de cada index.md con pdf_version: true."
	@echo "  build             Construye el sitio web estático."
	@echo "  serve             Lanza un servidor de desarrollo con livereload."
	@echo "  clean-mc2mr-images   Elimina los PNG generados para MC→MR."
	@echo "  clean-req2sql-images Elimina los PNG generados para Req→SQL."
	@echo "  clean-grades-images  Elimina los SVG generados para grades."
	@echo "  clean-images         Ejecuta todos los clean."

# Render PlantUML diagrams and update public PNGs for MC2MR
mc2mr-images:
	bash _scripts/export_mc2mr.sh

# Render PlantUML diagrams and update public PNGs for Req→MC→MR→SQL
req2sql-images:
	bash _scripts/export_req2sql.sh

# Render PlantUML diagrams for grades/requisitos
grades-images:
	bash _scripts/export_grades.sh

# Alias to render all images
images: mc2mr-images req2sql-images grades-images

# Generate PDF versions from markdown indexes (requires pdf_version: true)
pdfs:
	python3 _scripts/build_pdfs.py

# Remove generated PNGs from public assets
clean-mc2mr-images:
	rm -f assets/images/mc2mr/*.png || true

clean-req2sql-images:
	rm -f assets/images/req2sql/**/*.png assets/images/req2sql/*.png 2>/dev/null || true

clean-grades-images:
	rm -f assets/images/iissi1/laboratorios/fig/req/*.svg 2>/dev/null || true

clean-images: clean-mc2mr-images clean-req2sql-images clean-grades-images

# Build the static website
build:
	bundle exec jekyll build
	mkdir -p _site/assets/DB-Silence-IISSI-1
	cp -r assets/DB-Silence-IISSI-1/* _site/assets/DB-Silence-IISSI-1/

# Serve the website with livereload
serve:
	bundle exec jekyll serve --livereload
