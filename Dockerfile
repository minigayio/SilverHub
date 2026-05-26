FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server \
    openssh-client \
    autossh \
    sudo \
    curl \
    wget \
    python3 \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

EXPOSE 8080

CMD bash -c '\
set -e; \

ROOT_USER=${ROOT_USER:-root}; \
ROOT_PASS=${ROOT_PASS:-123456}; \

if ! id "$ROOT_USER" >/dev/null 2>&1; then \
    useradd -m -s /bin/bash "$ROOT_USER"; \
fi; \

echo "$ROOT_USER:$ROOT_PASS" | chpasswd; \
usermod -aG sudo "$ROOT_USER"; \

grep -q "^$ROOT_USER " /etc/sudoers || \
echo "$ROOT_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers; \

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config; \
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config; \

echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; \
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config; \
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config; \
echo "ClientAliveCountMax 999" >> /etc/ssh/sshd_config; \
echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config; \

/usr/sbin/sshd -p 10000; \

python3 -m http.server 8080 --bind 0.0.0.0 & \

echo "======================================"; \
echo "SSH USER: $ROOT_USER"; \
echo "SSH PASS: $ROOT_PASS"; \
echo "Waiting Pinggy tunnel..."; \
echo "======================================"; \

autossh \
-M 0 \
-N \
-o "ServerAliveInterval 30" \
-o "ServerAliveCountMax 3" \
-o "StrictHostKeyChecking=no" \
-o "ExitOnForwardFailure=yes" \
-p 443 \
-R0:localhost:10000 \
a.pinggy.io \
'
