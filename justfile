default: build push

build:
  buildah unshare ./build.sh

push:
  buildah push docker.io/edgecube/boxkit:latest
