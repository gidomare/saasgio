#!/bin/sh
set -e

# Wait for database availability (optional, good practice)
# simple sleep for now, or use wait-for interaction if needed.
echo "Starting application..."

# Run migrations if this is a web container startup
# Depending on orchestration, might want to do this manually or in a deploy job.
# For simplicity in dev/one-box setups:
if [ -f "artisan" ]; then
    echo "Running migrations..."
    php artisan migrate --force
fi

# Execute the passed command (usually php-fpm)
exec "$@"
