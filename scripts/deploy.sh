#!/bin/bash

# /var/www/asphalt/scripts/deploy.sh

# Exit on any error
set -e

# Configuration
APP_DIR="/var/www/asphalt"
LOG_FILE="/var/log/asphalt-deploy.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
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
npm install --production

# Update permissions if needed
log_message "Updating permissions"
sudo chown -R fredp614:fredp614 .
sudo chmod -R 755 .

# Restart the application
log_message "Restarting application"
sudo systemctl restart asphalt

# Test and reload Nginx
log_message "Testing and reloading Nginx"
sudo nginx -t && sudo systemctl reload nginx

# Clean up
log_message "Cleaning up"
sudo rm -rf /tmp/mcguire-asphalt

log_message "Deployment completed successfully"