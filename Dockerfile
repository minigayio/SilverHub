FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt curl và các thư viện cần thiết
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Tải trực tiếp bản binary sshx chính thức
RUN curl -sSLO https://github.com/ekzhang/sshx/releases/latest/download/sshx-linux-amd64.tar.gz \
    && tar -xzf sshx-linux-amd64.tar.gz \
    && mv sshx /usr/local/bin/ \
    && rm sshx-linux-amd64.tar.gz

WORKDIR /root

# Viết script khởi động: Chạy sshx dưới dạng Server lắng nghe ở port của Render
RUN echo '#!/bin/bash\n\
# Render cấp port nào thì sshx server sẽ chạy ở port đó\n\
echo "Starting self-hosted sshx server on port $PORT..."\n\
\n\
# Khởi động sshx server. Vì Render xử lý SSL (https) ở lớp ngoài rồi, \n\
# nên ở trong container mình chỉ cần chạy giao thức http thường.\n\
sshx server --port $PORT\n\
' > /start.sh

RUN chmod +x /start.sh

USER root

CMD ["/bin/bash", "/start.sh"]
