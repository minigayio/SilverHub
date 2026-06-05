#!/bin/bash
set -e

# ---------------------------------------------------------------
# Render.com injects $PORT at runtime — honour it.
# Fall back to 8080 if running locally.
# ---------------------------------------------------------------
PORT="${PORT:-8080}"

# ---------------------------------------------------------------
# Allow PASSWORD to be set via Render Environment Variable.
# Falls back to the build-arg default.
# ---------------------------------------------------------------
CS_PASSWORD="${PASSWORD:-changeme}"

# ---------------------------------------------------------------
# Update root password if ROOT_PASSWORD env var is provided
# ---------------------------------------------------------------
if [ -n "${ROOT_PASSWORD}" ]; then
  echo "root:${ROOT_PASSWORD}" | chpasswd
fi

# ---------------------------------------------------------------
# Write a fresh config.yaml with the runtime values
# ---------------------------------------------------------------
mkdir -p /root/.config/code-server
cat > /root/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:${PORT}
auth: password
password: ${CS_PASSWORD}
cert: false
EOF

echo "=== code-server starting on port ${PORT} ==="

# Run as root so the terminal has full root access
exec code-server \
  --user-data-dir /root/.local/share/code-server \
  --extensions-dir /root/.local/share/code-server/extensions \
  /root
