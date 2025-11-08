# Use Python 3.13 as base image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Install uv package manager
RUN pip install --no-cache-dir uv

# Copy project files
COPY pyproject.toml uv.lock ./
COPY emby_mcp_server.py ./
COPY lib_emby_functions.py ./
COPY lib_emby_debugging.py ./
COPY hotfixes/ ./hotfixes/
COPY LICENSE.txt ./
COPY docker-entrypoint.sh ./

# Install dependencies using uv
RUN uv sync --link-mode=copy

# Apply hotfix patches
# Find the emby_client package location in the virtual environment
RUN cp hotfixes/emby/configuration.py    .venv/lib/python3.13/site-packages/emby_client && \
    cp hotfixes/emby/user_service_api.py .venv/lib/python3.13/site-packages/emby_client/api

# Make entrypoint script executable
RUN chmod +x docker-entrypoint.sh

# Expose default HTTP port (can be overridden via environment variable)
EXPOSE 8000

# Set default transport to HTTP (can be overridden via environment variable or command line)
ENV MCP_TRANSPORT=streamable-http
ENV MCP_HTTP_HOST=0.0.0.0
ENV MCP_HTTP_PORT=8000
ENV MCP_HTTP_PATH=/mcp

# Emby configuration environment variables (can be overridden at runtime)
ENV EMBY_SERVER_URL=http://localhost:8096
ENV EMBY_USERNAME=
ENV EMBY_PASSWORD=
ENV EMBY_VERIFY_SSL=True
ENV LLM_MAX_ITEMS=100

# Set entrypoint to generate .env file from environment variables
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Run the server
# Use uv run to ensure dependencies are available
CMD ["uv", "run", "emby_mcp_server.py"]

