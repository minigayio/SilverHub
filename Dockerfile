FROM debian:bookworm-slim

# Cài đặt các công cụ hệ thống bắt buộc (bổ sung thêm 'procps' và 'gzip' để script code-server chạy được)
RUN apt update && apt install -y \
    curl \
    wget \
    sudo \
    git \
    build-essential \
    procps \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# Đổi mật khẩu của tài khoản root trong Linux thành "root"
RUN echo 'root:root' | chpasswd

# Tải và cài đặt chính xác script của Code-Server
RUN curl -fsSL https://code-server.dev | sh

# Tạo thư mục lưu cấu hình dự án
RUN mkdir -p /root/.config/code-server

# Mở cổng mạng theo tiêu chuẩn Render
EXPOSE 10000

# Khởi chạy code-server trên cổng 10000 và sử dụng biến PASSWORD làm mật khẩu đăng nhập web
CMD ["code-server", "--bind-addr", "0.0.0.0:10000", "--auth", "password"]
