FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl sudo && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8080

CMD bash -c '\
echo "root:${ROOT_PASSWORD:-root}" | chpasswd; \
mkdir -p /root/.config/code-server; \
cat > /root/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${PORT:-8080}
auth: password
password: ${PASSWORD:-admin}
cert: false
EOF
exec code-server --user-data-dir /root/.local/share/code-server'
