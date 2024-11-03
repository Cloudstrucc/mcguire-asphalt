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

# Get user input
read -p "Enter the new sudo user to create: " NEW_USER
read -p "Enter the domain name (e.g., example.com): " DOMAIN
read -p "Include www subdomain? (y/n): " INCLUDE_WWW

# Update system
print_status "Updating system packages..."
apt-get update
apt-get upgrade -y

# Create new user and add to sudo group
print_status "Creating new user and adding to sudo group..."
adduser $NEW_USER
usermod -aG sudo $NEW_USER

# Basic security configurations
print_status "Configuring SSH..."
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh reload || systemctl reload ssh.service

# Install and configure UFW
print_status "Setting up firewall..."
apt-get install -y ufw
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw --force enable

# Install Nginx
print_status "Installing Nginx..."
apt-get install -y nginx

# Install Let's Encrypt
print_status "Installing Let's Encrypt..."
apt-get install -y certbot python3-certbot-nginx

# Configure Nginx for domain
print_status "Configuring Nginx..."
cat > /etc/nginx/sites-available/$DOMAIN << EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN$([ "$INCLUDE_WWW" = "y" ] && echo " www.$DOMAIN");
    
    root /var/www/$DOMAIN/html;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Create web root directory
mkdir -p /var/www/$DOMAIN/html

# Create sample index.html
cat > /var/www/$DOMAIN/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $DOMAIN!</title>
</head>
<body>
    <h1>Success! Your web server is running.</h1>
</body>
</html>
EOF

# Set proper permissions
chown -R www-data:www-data /var/www/$DOMAIN
chmod -R 755 /var/www/$DOMAIN

# Enable site
ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
nginx -t

# Restart Nginx
systemctl restart nginx

# Install Node.js and npm
print_status "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

print_status "Setup complete! Your server is now configured with:"
echo "- New sudo user: $NEW_USER"
echo "- UFW firewall enabled with HTTP, HTTPS, and SSH access"
echo "- Nginx installed and configured"
echo "- Node.js and npm installed"
echo ""
echo "Next steps:"
echo "1. Log out and log back in as $NEW_USER"
echo "2. Run the website deployment script"
echo "3. Consider additional security measures like fail2ban"