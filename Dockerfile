# Sử dụng bản Ubuntu mới nhất
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV DISPLAY=:1

# 1. Cập nhật hệ thống và cài đặt các công cụ cơ bản + SUPERVISOR để chống sập
RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nano net-tools xvfb x11vnc openbox supervisor \
    && rm -rf /var/lib/apt/lists/*

# 2. Tải và cài đặt noVNC + websockify
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# 3. Tải và cài đặt sshx client bằng quyền root
RUN curl -sSf https://sshx.io/get | sh

WORKDIR /root

# 4. Tạo file cấu hình cho Supervisor để quản lý, giữ các tiến trình luôn SỐNG
RUN echo '[supervisord]\n\
nodaemon=true\n\
user=root\n\
\n\
[program:xvfb]\n\
command=Xvfb :1 -screen 0 1280x720x24\n\
autorestart=true\n\
\n\
[program:openbox]\n\
command=openbox-session\n\
autorestart=true\n\
\n\
[program:x11vnc]\n\
command=x11vnc -display :1 -nopw -forever -shared -rfbport 5900\n\
autorestart=true\n\
\n\
[program:sshx]\n\
command=sshx\n\
autorestart=true\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
\n\
[program:novnc]\n\
command=/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen %(environ(PORT))s\n\
autorestart=true\n' > /etc/supervisor/conf.d/supervisord.conf

# Render sẽ tự cấp cổng PORT ngẫu nhiên
EXPOSE 8080

# 5. Khởi chạy thông qua tập lệnh dọn dẹp lock cũ và gọi Supervisor
CMD ["sh", "-c", "rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
