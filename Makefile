# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
# THIS_FILE := $(lastword $(MAKEFILE_LIST))
THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

include vars.mk

.PHONY: build-and-push
build-and-push: ## build and push multiplatform Docker image to Docker Hub
	# linux/amd64 (e.g., intel), linux/arm64/v8 (e.g., Apple Silicon), linux/arm/v7 (e.g., Raspberry Pi)
	docker buildx build --platform linux/amd64 -t $(DOCKER_IMAGE) --push .

.PHONY: build-amd64
build-amd64: ## build linux/amd64 Docker image locally
	docker buildx build --platform linux/amd64 -t $(DOCKER_IMAGE) -t $(DOCKER_REPO):latest --load .

.PHONY: build-arm64
build-arm64: ## build linux/arm64 Docker image locally
	docker buildx build --platform linux/arm64/v8 -t $(DOCKER_IMAGE) -t $(DOCKER_REPO):latest --load .

.PHONY: help
help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help
