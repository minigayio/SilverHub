FROM alpine:latest

# Cài đặt OpenSSH, bash và shadow (để dùng lệnh useradd/chsh)
RUN apk update && apk add --no-cache openssh bash shadow

# Tạo SSH host keys tự động
RUN ssh-keygen -A

# Cấu hình SSH để cho phép đăng nhập bằng mật khẩu
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Mở cổng 22 bên trong container
EXPOSE 22

# Script khởi chạy: Tự động tạo user từ Biến Môi Trường khi Render boot container
RUN echo '#!/bin/bash \n\
USER_NAME=${SSH_USER:-admin} \n\
USER_PASS=${SSH_PASSWORD:-Password123} \n\
\n\
# Tạo user nếu chưa tồn tại \n\
if ! id "$USER_NAME" &>/dev/null; then \n\
    useradd -m -s /bin/bash "$USER_NAME" \n\
fi \n\
\n\
# Cập nhật mật khẩu \n\
echo "$USER_NAME:$USER_PASS" | chpasswd \n\
\n\
# Tạo thư mục chứa file và phân quyền \n\
mkdir -p /home/"$USER_NAME"/upload \n\
chown -R "$USER_NAME":"$USER_NAME" /home/"$USER_NAME" \n\
\n\
echo "=== SSH/SFTP Server Started ===" \n\
echo "User: $USER_NAME" \n\
\n\
exec /usr/sbin/sshd -D' > /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
