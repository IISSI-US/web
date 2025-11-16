# Simple Makefile for image exports and related tooling

.PHONY: mc2mr-images req2sql-images images pdfs clean-images clean-mc2mr-images clean-req2sql-images

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
