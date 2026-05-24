# Sử dụng Alpine Linux cho nhẹ, hoặc đổi thành "ubuntu:latest" nếu bạn quen dùng apt-get
FROM alpine:latest

# Cài đặt các công cụ cơ bản và các thư viện cần thiết cho việc cài đặt sau này
RUN apk update && apk add --no-cache \
    curl \
    bash \
    git \
    nano \
    build-base

# Tải và cài đặt sshx client
RUN curl -sSf https://sshx.io/get | sh

# Thiết lập thư mục làm việc tại ngôi nhà của root
WORKDIR /root

# Thiết lập biến môi trường mặc định là bash shell
ENV SHELL=/bin/bash

# Khởi chạy Bash Shell trước, bạn thích bật sshx lúc nào thì gõ lệnh `sshx` lúc đó
CMD ["/bin/bash"]
