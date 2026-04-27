.PHONY: help setup lab run run-one clean export dirs

PYTHON := python
PIP := pip

NOTEBOOKS := notebooks
DOCS := docs
RESULTS := results
FIGURES := figures
MATH := math

help:
@echo "pi-stage-lab commands:"
@echo "  make setup        Install requirements"
@echo "  make lab          Start JupyterLab"
@echo "  make run          Execute ALL notebooks"
@echo "  make run-one N=00 Run a single notebook (e.g., N=00)"
@echo "  make clean        Remove generated outputs"
@echo "  make export       Zip docs/results/figures"

setup:
$(PIP) install -r requirements.txt

lab:
jupyter lab

dirs:
mkdir -p $(DOCS) $(RESULTS) $(FIGURES) $(MATH)
touch $(RESULTS)/.keep $(FIGURES)/.keep

run: dirs
@for nb in $(NOTEBOOKS)/*.ipynb; do 
echo "Running $$nb"; 
jupyter nbconvert --to notebook --execute --inplace $$nb; 
done

run-one: dirs
	@nb=$$(ls $(NOTEBOOKS)/$(N)_*.ipynb 2>/dev/null); \
	if [ -z "$$nb" ]; then \
		echo "No notebook found for prefix $(N)_"; \
	else \
		echo "Running $$nb"; \
		jupyter nbconvert --to notebook --execute --inplace $$nb; \
	fi

clean:
rm -rf $(RESULTS)/* $(FIGURES)/* *.zip
touch $(RESULTS)/.keep $(FIGURES)/.keep

export: dirs
zip -r pi-stage-lab_export.zip $(DOCS) $(RESULTS) $(FIGURES) $(MATH) README.md
