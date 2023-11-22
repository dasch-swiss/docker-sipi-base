# SIPI Base Docker Image

Docker image containing the base environment necessary to build and run the SIPI (Simple Image Presentation Interface) Server: <https://github.com/dasch-swiss/sipi>

## Usage

In your dockerfile add:

```Dockerfile
FROM daschswiss/sipi-base:2.19.0
```

## Multiplatform Build Resources

- Docker for Mac: <https://docs.docker.com/docker-for-mac/multi-arch/>
- Docker Buildx: <https://docs.docker.com/buildx/working-with-buildx/>
