HOST ?= ubuntu-24

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

.PHONY: install-k3d
install-k3d: ## Install k3d
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

.PHONY: install-kubectl
install-kubectl: ## Install kubectl
	@echo "🔍 Detecting platform and architecture..."
	@ARCH=$$(uname -m); \
	case $$ARCH in \
	  x86_64) ARCH=amd64 ;; \
	  arm64|aarch64) ARCH=arm64 ;; \
	  *) echo "❌ Unsupported architecture: $$ARCH" && exit 1 ;; \
	esac; \
	OS=$$(uname | tr '[:upper:]' '[:lower:]'); \
	if [ "$$OS" != "linux" ] && [ "$$OS" != "darwin" ]; then \
		echo "❌ Unsupported OS: $$OS"; exit 1; \
	fi; \
	VERSION=$$(curl -L -s https://dl.k8s.io/release/stable.txt); \
	URL="https://dl.k8s.io/release/$$VERSION/bin/$$OS/$$ARCH/kubectl"; \
	echo "⬇️ Downloading kubectl $$VERSION for $$OS/$$ARCH..."; \
	curl -LO "$$URL"; \
	chmod +x kubectl; \
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
	rm -f kubectl; \
	echo "✅ kubectl installed to /usr/local/bin"
