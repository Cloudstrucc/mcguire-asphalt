#!/bin/bash

# Exit on any error
set -e

# Configuration
APP_DIR="/home/fredp614/asphalt-app"
TEMPLATE_DIR="${APP_DIR}/Construction"
APP_USER="fredp614"
REPO_URL="https://github.com/Cloudstrucc/mcguire-asphalt.git"
TEMP_DIR="/tmp/mcguire-asphalt"

# Function to print status messages
print_status() {
    echo "===> $1"
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

print_status "Starting deployment..."

# Clean up any existing temporary files
if [ -d "$TEMP_DIR" ]; then
    print_status "Cleaning up old temporary files..."
    rm -rf "$TEMP_DIR"
fi

# Clone the repository
print_status "Cloning repository..."
git clone $REPO_URL $TEMP_DIR

# Create application directory if it doesn't exist
if [ ! -d "$APP_DIR" ]; then
    print_status "Creating application directory..."
    mkdir -p "$APP_DIR"
fi

# Create Construction directory if it doesn't exist
if [ ! -d "$TEMPLATE_DIR" ]; then
    print_status "Creating Construction directory..."
    mkdir -p "$TEMPLATE_DIR"
fi

# Copy template files
print_status "Copying template files..."
cp -r $TEMP_DIR/Construction/* "$TEMPLATE_DIR/"

# Create app.js
print_status "Creating Node.js application..."
cat > "$APP_DIR/app.js" << 'EOF'
const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'", "*.googleapis.com", "*.gstatic.com"],
            styleSrc: ["'self'", "'unsafe-inline'", "*.googleapis.com"],
            scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'", "*.googleapis.com"],
            fontSrc: ["'self'", "fonts.gstatic.com", "*.googleapis.com"],
            imgSrc: ["'self'", "data:", "*.githubusercontent.com", "*"],
            connectSrc: ["'self'"],
            objectSrc: ["'none'"]
        }
    }
}));

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from the Construction directory
app.use(express.static(path.join(__dirname, 'Construction')));

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'healthy' });
});

// Main route
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'Construction', 'index.html'));
});

// Handle 404s
app.use((req, res) => {
    res.status(404).sendFile(path.join(__dirname, 'Construction', 'index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
EOF

# Create package.json
print_status "Creating package.json..."
cat > "$APP_DIR/package.json" << EOF
{
  "name": "asphalt-website",
  "version": "1.0.0",
  "description": "McGuire Asphalt Website",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "dev": "nodemon app.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
EOF

# Set correct permissions
print_status "Setting permissions..."
chown -R $APP_USER:$APP_USER "$APP_DIR"
chmod -R 755 "$APP_DIR"

# Install dependencies
print_status "Installing dependencies..."
cd "$APP_DIR"
su - $APP_USER -c "cd ${APP_DIR} && npm install express cors helmet dotenv"

# Create systemd service file
print_status "Creating systemd service..."
cat > /etc/systemd/system/asphalt.service << EOF
[Unit]
Description=Asphalt Node.js Website
After=network.target

[Service]
Type=simple
User=$APP_USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/node app.js
Restart=on-failure
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and restart the service
print_status "Starting application service..."
systemctl daemon-reload
systemctl enable asphalt
systemctl restart asphalt

# Update Nginx configuration
print_status "Configuring Nginx..."
cat > /etc/nginx/sites-available/asphalt.cloudstrucc.com << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name asphalt.cloudstrucc.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Add caching for static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        proxy_pass http://localhost:3000;
        proxy_cache_bypass $http_upgrade;
        expires 7d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/asphalt.cloudstrucc.com /etc/nginx/sites-enabled/

# Clean up temporary files
print_status "Cleaning up..."
rm -rf $TEMP_DIR

# Test and reload Nginx test
print_status "Reloading Nginx..."
nginx -t && systemctl reload nginx

print_status "Deployment complete!"
echo "Your website should now be accessible at http://asphalt.cloudstrucc.com"
echo ""
echo "To check the application status:"
echo "sudo systemctl status asphalt"
echo ""
echo "To view logs:"
echo "sudo journalctl -u asphalt -f"