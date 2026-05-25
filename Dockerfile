FROM alpine:latest

RUN apk add --no-cache \
    bash \
    curl \
    busybox-extras

RUN curl -sSf https://sshx.io/get | sh

EXPOSE 10000

CMD sh -c '
while true; do
    sshx
    sleep 2
done &

while true; do
    echo ok | nc -lk -p 10000 > /dev/null 2>&1
done
'
