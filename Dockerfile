# ============================================================
#  code-server on Render.com — with root terminal access
# ============================================================
FROM ubuntu:22.04

# --- Build-time defaults (override in Render Environment Variables) ---
ARG CS_PASSWORD=changeme
ARG ROOT_PASSWORD=changeme

ENV DEBIAN_FRONTEND=noninteractive \
    PASSWORD=${CS_PASSWORD} \
    ROOT_PASSWORD=${ROOT_PASSWORD} \
    HOME=/root \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# --- System packages ---
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    bash \
    sudo \
    locales \
    ca-certificates \
    procps \
    htop \
    vim \
    nano \
    unzip \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- Set root password (for su / terminal use) ---
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# --- Install code-server (latest) ---
RUN curl -fsSL https://code-server.dev/install.sh | sh

# --- code-server config ---
RUN mkdir -p /root/.config/code-server
COPY config.yaml /root/.config/code-server/config.yaml

# --- Entrypoint script to inject runtime env vars into config ---
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Render assigns PORT dynamically; code-server listens on it
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
