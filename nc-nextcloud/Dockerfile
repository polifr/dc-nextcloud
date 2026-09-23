FROM nextcloud:34

USER root
RUN apt update && \
    apt install -y \
        imagemagick \
        ghostscript \
    && rm -rf /var/lib/apt/lists/*
