SHELL := /usr/bin/env bash

.PHONY: lock check build test hashes

lock:
	nix flake lock

check:
	nix flake check

build:
	nix build .#rosa

test:
	./scripts/test-package.sh

hashes:
	@if [ -z "$(VERSION)" ]; then \
		echo "Usage: make hashes VERSION=v1.2.60"; \
		exit 1; \
	fi
	./scripts/compute-hashes.sh $(VERSION)
