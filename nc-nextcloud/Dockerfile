FROM nextcloud:35

USER root
RUN apt update && \
    apt install -y \
        imagemagick \
        ghostscript \
    && rm -rf /var/lib/apt/lists/*
