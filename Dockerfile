# pgvector PostgreSQL Docker Image for Coolify
# https://github.com/pgvector/pgvector

FROM pgvector/pgvector:pg16

# Copy initialization script
COPY ./init-scripts/ /docker-entrypoint-initdb.d/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pg_isready -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-postgres} || exit 1

# Expose PostgreSQL port (can be remapped via docker-compose or Coolify)
EXPOSE 5432

# Data volume for persistence and backup
VOLUME ["/var/lib/postgresql/data"]
