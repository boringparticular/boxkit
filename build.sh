#!/usr/bin/env bash

set -x

ctr=$(buildah from "quay.io/toolbx-images/alpine-toolbox:edge")

buildah config --label com.github.containers.toolbox="true" "$ctr"
buildah config --label usage="This image is meant to be used with the toolbox or distrobox command" "$ctr"
buildah config --label summary="A cloud-native terminal experience" "$ctr"
buildah config --label maintainer="develop@regnavi.de>" "$ctr"

buildah mount "$ctr"

buildah copy "$ctr" extra-packages /

buildah run "$ctr" -- sh -c 'apk update && \
    apk upgrade && \
    grep -v "^#" /extra-packages | xargs apk add'

buildah run "$ctr" -- rm /extra-packages

buildah run "$ctr" -- sh -c 'echo /usr/bin/zsh >> /etc/shells'

buildah run "$ctr" -- sh -c 'ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/rpm-ostree'

buildah umount "$ctr"

buildah commit "$ctr" "docker.io/edgecube/boxkit:latest"

buildah rm "$ctr"
