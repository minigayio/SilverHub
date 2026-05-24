FROM ubuntu:22.04

# Thiết lập môi trường không tương tác
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt curl để lấy link sshx và python3 để tạo cổng giữ ping cho Render
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Đảm bảo chạy bằng quyền root
USER root

# Lệnh CMD này thực hiện 3 việc trực tiếp khi container KHỞI ĐỘNG (Runtime):
# 1. Bật web server fake ở port Render cấp để tránh lỗi "Port timeout" / ngủm sau 15p
# 2. Tải trực tiếp sshx từ trang chủ sshx.io bằng lệnh chính thức (Lúc này mạng Render đã mở)
# 3. Chạy sshx server liên tục trên Port đó
CMD echo "OK" > index.html && \
    python3 -m http.server $PORT & \
    echo "Downloading sshx from official site..." && \
    curl -sSf https://sshx.io/install.sh | sh && \
    echo "Starting self-hosted sshx server on port $PORT..." && \
    export SHELL=/bin/bash && \
    /root/.sshx/bin/sshx server --port $PORT
