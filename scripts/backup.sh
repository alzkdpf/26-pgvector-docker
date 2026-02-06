#!/bin/bash
# PostgreSQL Backup Script for pgvector database
# Usage: ./backup.sh [container_name]

set -e

CONTAINER_NAME="${1:-pgvector-db}"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-vectordb}"

echo "Starting backup of database: $POSTGRES_DB"
echo "Timestamp: $TIMESTAMP"

# Create backup using pg_dump
docker exec "$CONTAINER_NAME" pg_dump \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -F custom \
    -f "/backups/${POSTGRES_DB}_${TIMESTAMP}.dump"

# Also create a plain SQL backup for portability
docker exec "$CONTAINER_NAME" pg_dump \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -F plain \
    -f "/backups/${POSTGRES_DB}_${TIMESTAMP}.sql"

# Compress the SQL backup
gzip -f "$BACKUP_DIR/${POSTGRES_DB}_${TIMESTAMP}.sql"

echo "Backup completed successfully!"
echo "Files created:"
echo "  - $BACKUP_DIR/${POSTGRES_DB}_${TIMESTAMP}.dump (custom format)"
echo "  - $BACKUP_DIR/${POSTGRES_DB}_${TIMESTAMP}.sql.gz (compressed SQL)"

# Optional: Remove backups older than 7 days
find "$BACKUP_DIR" -type f -mtime +7 -delete 2>/dev/null || true
echo "Old backups (>7 days) cleaned up."
