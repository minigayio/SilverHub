# Sử dụng bản Ubuntu mới nhất
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nano net-tools xvfb x11vnc openbox \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

RUN curl -sSf https://sshx.io/get | sh

WORKDIR /root

# Render sẽ tự cấp PORT, chúng ta không cần ghim cứng EXPOSE nữa
EXPOSE 8080

# Chỉnh sửa lệnh chạy: noVNC sẽ lắng nghe biến $PORT do Render ép xuống
CMD ["sh", "-c", "\
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 && \
    Xvfb :1 -screen 0 1280x720x24 & \
    sleep 2 && \
    openbox-session & \
    x11vnc -display :1 -nopw -forever -shared -listen localhost & \
    /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen ${PORT:-8080} & \
    sshx & \
    while true; do sleep 3600; done \
    "]
