#!/bin/bash

# Exit on error
set -e

# Load environment variables
source .env

# Create backup directory if it doesn't exist
BACKUP_DIR="backups/$(date +%Y-%m-%d)"
mkdir -p $BACKUP_DIR

echo "📦 Starting backup process..."

# Backup each database
echo "💾 Backing up databases..."
for DB in services services_duplicate; do
    echo "  📀 Backing up $DB..."
    mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $DB > "$BACKUP_DIR/$DB.sql"
done

# Backup configuration files
echo "⚙️ Backing up configuration files..."
cp .env "$BACKUP_DIR/.env.backup"
cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml.backup"
cp frontend/nginx.conf "$BACKUP_DIR/nginx.conf.backup"

# Create archive
echo "📚 Creating backup archive..."
ARCHIVE_NAME="mysql-mcp-backup-$(date +%Y-%m-%d).tar.gz"
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C $BACKUP_DIR .

# Cleanup individual files
rm "$BACKUP_DIR"/*.sql "$BACKUP_DIR"/*.backup

echo "✅ Backup completed successfully!"
echo "📍 Backup location: $BACKUP_DIR/$ARCHIVE_NAME"

# Optional: Upload to remote storage
if [ ! -z "$BACKUP_REMOTE_PATH" ]; then
    echo "☁️ Uploading backup to remote storage..."
    # Add your preferred upload command here (e.g., aws s3 cp, scp, rsync)
    # Example for AWS S3:
    # aws s3 cp "$BACKUP_DIR/$ARCHIVE_NAME" "s3://$BACKUP_REMOTE_PATH/"
fi 