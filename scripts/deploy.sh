#!/bin/bash

# /home/fredp614/deploy.sh

# Exit on any error
set -e

# Configuration
APP_DIR="/home/fredp614/asphalt-app"
LOG_FILE="/var/log/asphalt-deploy.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Start deployment
log_message "Starting deployment"

# Navigate to app directory
cd "$APP_DIR"

# Pull latest changes
log_message "Pulling latest changes"
git pull origin main

# Install dependencies
log_message "Installing dependencies"
npm install --omit=dev

# Update permissions if needed
log_message "Updating permissions"
sudo /bin/chown -R fredp614:fredp614 /home/fredp614/asphalt-app
sudo /bin/chmod -R 755 /home/fredp614/asphalt-app

# Restart the application
log_message "Restarting application"
sudo /bin/systemctl restart asphalt

# Test and reload Nginx
log_message "Testing and reloading Nginx"
sudo /usr/sbin/nginx -t && sudo /bin/systemctl reload nginx

# Clean up
log_message "Cleaning up"
rm -rf /tmp/mcguire-asphalt

log_message "Deployment completed successfully"