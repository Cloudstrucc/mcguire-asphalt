#!/bin/bash

# Exit on any error
set -e

# Function to print status messages
print_status() {
    echo "===> $1"
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

print_status "Starting maintenance tasks..."

# Update system packages
print_status "Updating system packages..."
apt-get update
apt-get upgrade -y

# Check SSL certificates
print_status "Checking SSL certificates..."
certbot renew --dry-run

# Check Nginx configuration
print_status "Checking Nginx configuration..."
nginx -t

# Check Node.js application status
print_status "Checking application status..."
systemctl status asphalt

# Check disk space
print_status "Checking disk space..."
df -h

# Check memory usage
print_status "Checking memory usage..."
free -h

# Check running processes
print_status "Checking running processes..."
ps aux | grep node

# Backup configuration files
BACKUP_DIR="/root/backups/$(date +%Y%m%d)"
print_status "Creating backup in $BACKUP_DIR..."
mkdir -p $BACKUP_DIR
cp /etc/nginx/sites-available/* $BACKUP_DIR/
cp /etc/systemd/system/asphalt.service $BACKUP_DIR/
cp -r /home/fredp614/asphalt-app/app.js $BACKUP_DIR/

print_status "Maintenance complete!"
echo "Backup files are stored in: $BACKUP_DIR"