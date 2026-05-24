FROM alpine:latest

# Cài đặt bash, curl để tải sshx, và python3 để giữ ping cho Render
RUN apk add --no-cache curl python3 bash

# Tải và cài đặt sshx.io
RUN curl -sSf https://sshx.io/install.sh | sh

WORKDIR /root

# Viết script khởi động: Ép sshx sử dụng Bash Shell với quyền root
RUN echo '#!/bin/bash\n\
# 1. Chạy web server fake ở port do Render cấp để không bị lỗi deploy\n\
echo "Starting health check server on port $PORT..."\n\
echo "OK" > index.html\n\
python3 -m http.server $PORT &\n\
\n\
# 2. Chạy sshx với quyền root và chỉ định dùng bash shell\n\
echo "Starting sshx as root..."\n\
export SHELL=/bin/bash\n\
sshx --quiet\n\
' > /start.sh

RUN chmod +x /start.sh

# Đảm bảo container chạy bằng user root
USER root

CMD ["/bin/bash", "/start.sh"]
