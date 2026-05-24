FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt curl để tải sshx và các gói cơ bản
RUN apt-get update && apt-get install -y curl bash ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /root

USER root

# Viết tất cả lệnh trên 1 dòng đơn để tránh hoàn toàn lỗi rớt dòng (newline unexpected)
CMD echo "Downloading sshx..." && curl -sSf https://sshx.io/install.sh | sh && echo "Starting sshx on port $PORT..." && export SHELL=/bin/bash && /root/.sshx/bin/sshx --listen 0.0.0.0:$PORT
