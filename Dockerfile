# syntax=docker/dockerfile:1.7

ARG DEBIAN_VERSION=stable-20250520-slim
ARG UPSTREAM_REPO=https://github.com/Dadoum/anisette-v3-server.git
ARG UPSTREAM_REF=2ef18d7da2abe3a6d070aa478f774538b947aaa2

FROM debian:${DEBIAN_VERSION} AS source
ARG UPSTREAM_REPO
ARG UPSTREAM_REF
RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates git \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git init . \
 && git remote add origin "${UPSTREAM_REPO}" \
 && git fetch --depth 1 origin "${UPSTREAM_REF}" \
 && git checkout --detach FETCH_HEAD

FROM debian:${DEBIAN_VERSION} AS builder
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    ca-certificates \
    clang \
    dub \
    git \
    ldc \
    libplist-2.0-4 \
    libplist-dev \
    libssl-dev \
    libz-dev \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/anisette-v3-server
COPY --from=source /src/ ./
RUN DC=ldc2 dub build -c static --build-mode allAtOnce -b release --compiler=ldc2

FROM debian:stable-slim AS runtime
LABEL org.opencontainers.image.title="Unraid Anisette Server" \
      org.opencontainers.image.description="Self-hosted SideStore-compatible Anisette V3 server container for Docker and Unraid." \
      org.opencontainers.image.source="https://github.com/yayk0/anisette-server" \
      org.opencontainers.image.url="https://github.com/yayk0/anisette-server" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.base.name="github.com/Dadoum/anisette-v3-server"

RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates curl libplist-2.0-4 libplist-dev \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash Alcoholic \
 && mkdir -p /home/Alcoholic/.config/anisette-v3/lib/ /opt/anisette-v3/provisioning \
 && chown -R Alcoholic:Alcoholic /home/Alcoholic /opt/anisette-v3 \
 && chmod -R u+rwX /home/Alcoholic /opt/anisette-v3

WORKDIR /opt
COPY --from=builder /opt/anisette-v3-server/anisette-v3-server /opt/anisette-v3-server
RUN chown Alcoholic:Alcoholic /opt/anisette-v3-server \
 && chmod 0755 /opt/anisette-v3-server

USER Alcoholic
EXPOSE 6969
VOLUME ["/home/Alcoholic/.config/anisette-v3/lib/"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:6969/v3/client_info >/dev/null || exit 1
ENTRYPOINT ["/opt/anisette-v3-server"]
