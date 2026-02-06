#!/bin/bash
# PostgreSQL Restore Script for pgvector database
# Usage: ./restore.sh <backup_file> [container_name]

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file> [container_name]"
    echo "Example: $0 ./backups/vectordb_20240101_120000.dump"
    exit 1
fi

BACKUP_FILE="$1"
CONTAINER_NAME="${2:-pgvector-db}"

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-vectordb}"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Starting restore of database: $POSTGRES_DB"
echo "From backup: $BACKUP_FILE"

# Determine file type and restore accordingly
if [[ "$BACKUP_FILE" == *.dump ]]; then
    # Custom format restore
    BACKUP_FILENAME=$(basename "$BACKUP_FILE")
    docker cp "$BACKUP_FILE" "$CONTAINER_NAME:/tmp/$BACKUP_FILENAME"
    
    docker exec "$CONTAINER_NAME" pg_restore \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        --clean \
        --if-exists \
        "/tmp/$BACKUP_FILENAME"
    
    docker exec "$CONTAINER_NAME" rm "/tmp/$BACKUP_FILENAME"
    
elif [[ "$BACKUP_FILE" == *.sql.gz ]]; then
    # Compressed SQL restore
    gunzip -c "$BACKUP_FILE" | docker exec -i "$CONTAINER_NAME" psql \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB"
        
elif [[ "$BACKUP_FILE" == *.sql ]]; then
    # Plain SQL restore
    docker exec -i "$CONTAINER_NAME" psql \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" < "$BACKUP_FILE"
else
    echo "Error: Unsupported backup file format"
    echo "Supported formats: .dump, .sql, .sql.gz"
    exit 1
fi

echo "Restore completed successfully!"
