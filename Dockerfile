# Sử dụng Ubuntu hoặc Alpine tùy bạn, ở đây dùng Ubuntu cho phổ thông và đầy đủ package
FROM ubuntu:latest

# Cài đặt curl và các công cụ cơ bản bằng quyền root mặc định
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt sshx client
RUN curl -sSf https://sshx.io/get | sh

# Thiết lập thư mục làm việc
WORKDIR /root

# Render yêu cầu ứng dụng phải lắng nghe một cổng (Port).
# Mặc định Render sẽ cấp một cổng thông qua biến môi trường $PORT.
EXPOSE 8080

# Chạy sshx ở chế độ không tương tác, xuất log ra màn hình Render để bạn lấy link kết nối
CMD ["sh", "-c", "sshx & while true; do sleep 3600; done"]
