FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    ca-certificates \
    netcat-openbsd \
    bash \
    && rm -rf /var/lib/apt/lists/*

# install sshx
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /root

EXPOSE 10000

CMD bash -c '
while true; do
    echo "Starting sshx..."

    sshx &

    while true; do
        echo ok | nc -l -p 10000 >/dev/null 2>&1
    done

    sleep 2
done
'
