# Sử dụng Ubuntu mới nhất
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

# 1. Cập nhật hệ thống, cài curl, bash và NGINX (để làm cổng kết nối ra link Render)
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# 2. Tải và cài đặt sshx client
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /root

# Render sẽ cấp cổng mạng qua biến $PORT, mặc định là 8080
EXPOSE 8080

# 3. Chạy lệnh: Cấu hình nhanh Nginx để chuyển hướng link Render vào sshx local, sau đó khởi chạy hệ thống
CMD ["sh", "-c", "\
    echo 'server {\n\
        listen '"${PORT:-8080}"';\n\
        location / {\n\
            proxy_pass http://127.0.0.1:8181;\n\
            proxy_http_version 1.1;\n\
            proxy_set_header Upgrade $http_upgrade;\n\
            proxy_set_header Connection \"Upgrade\";\n\
            proxy_set_header Host $host;\n\
        }\n\
    }' > /etc/nginx/sites-available/default && \
    nginx -g 'daemon on;' && \
    sshx --listen 127.0.0.1:8181 & \
    while true; do sleep 3600; done \
    "]
