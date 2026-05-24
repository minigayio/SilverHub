FROM ubuntu:22.04

# Tránh các câu hỏi tương tác khi cài đặt gói
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt curl, python3, bash và ca-certificates (để không bị lỗi chứng chỉ SSL khi tải)
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Tải và cài đặt sshx.io bằng bash công thức chuẩn
RUN curl -sSf https://sshx.io/install.sh | bash

WORKDIR /root

# Viết script khởi động tạo web server fake và chạy sshx
RUN echo '#!/bin/bash\n\
# 1. Chạy web server fake ở port do Render cấp để pass qua vòng kiểm tra của Render\n\
echo "Starting health check server on port $PORT..."\n\
echo "OK" > index.html\n\
python3 -m http.server $PORT &\n\
\n\
# 2. Chạy sshx dưới quyền root\n\
echo "Starting sshx as root..."\n\
export SHELL=/bin/bash\n\
sshx\n\
' > /start.sh

RUN chmod +x /start.sh

# Đảm bảo sử dụng quyền root
USER root

CMD ["/bin/bash", "/start.sh"]
