# Sử dụng bản Ubuntu mới nhất
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

# 1. Cập nhật hệ thống, cài đặt curl, bash, python3 và pip (để chạy websockify)
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 2. Cài đặt websockify để làm proxy chuyển hướng cổng mạng cho Render
RUN git clone https://github.com/novnc/websockify /opt/websockify

# 3. Tải và cài đặt sshx client bằng quyền root
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /root

# Khai báo biến môi trường sử dụng Bash làm mặc định
ENV SHELL=/bin/bash

# Mở cổng mặc định 8080 cho Render
EXPOSE 8080

# 4. Khởi chạy hệ thống (Sửa lại cú pháp dạng chuỗi đơn giản để không bị lỗi ký tự)
CMD sshx --listening-port 8181 & sleep 3 && python3 /opt/websockify/run ${PORT:-8080} 127.0.0.1:8181 & while true; do sleep 3600; done
