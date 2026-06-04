FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl sudo passwd && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8080

CMD bash -c '\
USERNAME=${USERNAME:-admin}; \
PASSWORD=${PASSWORD:-admin123}; \
ROOT_PASSWORD=${ROOT_PASSWORD:-root123}; \
if ! id "$USERNAME" >/dev/null 2>&1; then \
    useradd -m -s /bin/bash "$USERNAME"; \
fi; \
echo "$USERNAME:$PASSWORD" | chpasswd; \
echo "root:$ROOT_PASSWORD" | chpasswd; \
usermod -aG sudo "$USERNAME"; \
mkdir -p /home/$USERNAME/.config/code-server; \
printf "bind-addr: 0.0.0.0:%s\nauth: password\npassword: %s\ncert: false\n" "${PORT:-8080}" "$PASSWORD" > /home/$USERNAME/.config/code-server/config.yaml; \
chown -R $USERNAME:$USERNAME /home/$USERNAME; \
exec su - $USERNAME -c code-server'
