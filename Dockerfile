# Sử dụng bản Ubuntu mới nhất
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

# 1. Cập nhật hệ thống và cài đặt các công cụ cơ bản
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

# 2. Tải ttyd (Công cụ chuyển Terminal thành Web) bản mới nhất về cài đặt
RUN curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

WORKDIR /root

# Thiết lập biến môi trường sử dụng Bash làm mặc định
ENV SHELL=/bin/bash

# Mở cổng mặc định 8080 cho Render
EXPOSE 8080

# 3. Khởi chạy ttyd: Lắng nghe đúng cổng $PORT của Render và mở thẳng Bash Shell quyền Root
CMD ttyd -p ${PORT:-8080} bash
