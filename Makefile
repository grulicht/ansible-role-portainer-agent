HOST ?= debian-12

.PHONY: help
help: ## Display this help message
	@cat Makefile Makefile.venv 2>/dev/null | grep -E '^[a-zA-Z_-]+:.*?## .*$$' \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# https://github.com/sio/Makefile.venv
# Seamlessly manage Python virtual environment with a Makefile
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2023.04.17/Makefile.venv"
	echo "fb48375ed1fd19e41e0cdcf51a4a0c6d1010dfe03b672ffc4c26a91878544f82 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv

include Makefile.venv

.PHONY: all
all: Makefile.venv $(VENV) install test

.PHONY: install
install: Makefile.venv $(VENV)  ## Install test requirements and mock dependencies
	$(VENV)/pip install -r test-requirements.txt
	if [ -f requirements.yml ]; then \
		$(VENV)/ansible-galaxy install -r requirements.yml; \
	fi
	@mkdir -p library
	@if [ -n "$$(find ./library -maxdepth 1 -type f 2>/dev/null)" ]; then chmod +x ./library/*; fi

.PHONY: lint
lint: $(VENV) lint-yaml lint-ansible  ## Run all linters

.PHONY: lint-yaml
lint-yaml: install  ## Run yamllint
	$(VENV)/yamllint .

.PHONY: lint-ansible
lint-ansible: install ## Run ansiblelint
	$(VENV)/ansible-lint .

.PHONY: create
create: ## Start Molecule container
	$(VENV)/molecule create

.PHONY: destroy
destroy:  ## Destroy molecule container
	$(VENV)/molecule destroy

.PHONY: converge
converge:  ## Run ansible role on Molecule container
	$(VENV)/molecule converge

.PHONY: verify
verify: install  ## Run tests using Molecule
	$(VENV)/molecule verify

.PHONY: login
login: ## Log into Molecule container. Default is `debian-12` - change by variable `HOST`
	$(VENV)/molecule login -h $(HOST)

.PHONY: test
test: install  ## Run complete Molecule pipeline
	$(VENV)/molecule test
