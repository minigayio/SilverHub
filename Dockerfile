FROM debian:bookworm-slim

# Cài đặt các công cụ cơ bản cho Linux và Code-Server
RUN apt update && apt install -y \
    curl \
    wget \
    sudo \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Đổi mật khẩu của tài khoản root trong Linux thành "root"
RUN echo 'root:root' | chpasswd

# Tải và cài đặt phiên bản Code-Server mới nhất tự động
RUN curl -fsSL https://code-server.dev | sh

# Tạo thư mục lưu cấu hình dự án
RUN mkdir -p /root/.config/code-server

# Mở cổng mạng theo tiêu chuẩn Render
EXPOSE 10000

# Khởi chạy code-server trên cổng 10000 và bật tính năng xác thực mật khẩu
CMD ["code-server", "--bind-addr", "0.0.0.0:10000", "--auth", "password"]
