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

# Restart the application using systemctl
log_message "Restarting application"
systemctl --user restart asphalt

log_message "Deployment completed successfully"