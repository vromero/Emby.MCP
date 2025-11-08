#!/bin/bash
set -e

# Generate .env file from Docker environment variables
cat > /app/.env << EOF
#------------
# Generated from Docker environment variables
EMBY_SERVER_URL = "${EMBY_SERVER_URL:-http://localhost:8096}"
EMBY_USERNAME = "${EMBY_USERNAME:-}"
EMBY_PASSWORD = "${EMBY_PASSWORD:-}"
EMBY_VERIFY_SSL = "${EMBY_VERIFY_SSL:-True}"
LLM_MAX_ITEMS = "${LLM_MAX_ITEMS:-100}"
#------------
EOF

# Execute the main command
exec "$@"

