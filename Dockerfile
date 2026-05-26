FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server sudo curl wget nano \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

EXPOSE 10000

CMD bash -c '\
ROOT_USER=${ROOT_USER:-root}; \
ROOT_PASS=${ROOT_PASS:-123456}; \

if ! id "$ROOT_USER" >/dev/null 2>&1; then \
    useradd -m -s /bin/bash "$ROOT_USER"; \
fi; \

echo "$ROOT_USER:$ROOT_PASS" | chpasswd; \
usermod -aG sudo "$ROOT_USER"; \

echo "$ROOT_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers; \

sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config; \
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config; \

echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config; \
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config; \
echo "ClientAliveCountMax 999" >> /etc/ssh/sshd_config; \

exec /usr/sbin/sshd -D -p 10000 \
'
