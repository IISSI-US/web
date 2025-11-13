# Simple Makefile for image exports and related tooling

.PHONY: mc2mr-images images

# Render PlantUML diagrams and update public PNGs for MC2MR
mc2mr-images:
	bash _scripts/export_mc2mr.sh

# Alias
images: mc2mr-images

.PHONY: clean-images
# Remove generated MC2MR PNGs from public assets
clean-images:
	rm -f assets/images/mc2mr/*.png
