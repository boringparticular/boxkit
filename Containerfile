FROM quay.io/toolbx-images/alpine-toolbox:edge

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="develop@regnavi.de>"

COPY extra-packages /
RUN apk update && \
    apk upgrade && \
    grep -v '^#' /extra-packages | xargs apk add
RUN rm /extra-packages

RUN ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/zsh
