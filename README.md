### SIPI Base Docker Image
---------------------------------------------------

Docker image containing the base environment necessary to build and run the SIPI (Simple Image Presentation Interface ) Server: https://github.com/dhlab-basel/Sipi

#### Image tags
--------------------
  - 14.04 [Dockerfile](https://github.com/dhlab-basel/docker-sipi-base/tree/master/latest/Dockerfile)
  - 16.04, latest [Dockerfile](https://github.com/dhlab-basel/docker-sipi-base/tree/master/latest/Dockerfile)

#### Usage
---------------

In your dockerfile add:

````
FROM dhlabbasel/sipi-base
FROM dhlabbasel/sipi-base:latest
FROM dhlabbasel/sipi-base:14.04
````
