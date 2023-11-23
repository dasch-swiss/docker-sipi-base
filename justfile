DOCKER_REPO := "daschswiss/sipi-base"
BUILD_TAG := `git describe --tag --dirty --abbrev=7`
DOCKER_IMAGE := DOCKER_REPO + ":" + BUILD_TAG

# List all recipies
default:
	just --list --unsorted

# build linux/amd64 Docker image locally
build-amd64:
  docker buildx build --platform linux/amd64 -t {{DOCKER_IMAGE}}-amd64 -t {{DOCKER_REPO}}:latest --load .

# push previously build linux/amd64 image to Docker hub
push-amd64:
	docker push {{DOCKER_IMAGE}}-amd64

# build linux/arm64 Docker image locally
build-arm64:
	docker buildx build --platform linux/arm64 -t {{DOCKER_IMAGE}}-arm64 -t {{DOCKER_REPO}}:latest --load .

# push previously build linux/arm64 image to Docker hub
push-arm64:
	docker push {{DOCKER_IMAGE}}-arm64

# publish Docker manifest combining aarch64 and x86 published images
publish-manifest:
	docker manifest create {{DOCKER_IMAGE}} --amend {{DOCKER_IMAGE}}-amd64 --amend {{DOCKER_IMAGE}}-arm64
	docker manifest annotate --arch amd64 --os linux {{DOCKER_IMAGE}} {{DOCKER_IMAGE}}-amd64
	docker manifest annotate --arch arm64 --os linux {{DOCKER_IMAGE}} {{DOCKER_IMAGE}}-arm64
	docker manifest inspect {{DOCKER_IMAGE}}
	docker manifest push {{DOCKER_IMAGE}}
