.PHONY: validate lint rules help

help:
	@echo "make validate  - run all checks (rules + shell lint)"
	@echo "make rules     - sanity-check committed Snort .rules files"
	@echo "make lint      - shellcheck helper scripts (if shellcheck present)"

validate: rules lint

rules:
	@bash scripts/check-rules.sh

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck scripts/*.sh && echo "shellcheck: OK"; \
	else \
		echo "shellcheck not installed — skipping"; \
	fi
