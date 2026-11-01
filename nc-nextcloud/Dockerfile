ARG NEXTCLOUD_VERSION
FROM nextcloud:${NEXTCLOUD_VERSION}

USER root
RUN apt update && \
    apt install -y \
        imagemagick \
        ghostscript \
    && rm -rf /var/lib/apt/lists/*
