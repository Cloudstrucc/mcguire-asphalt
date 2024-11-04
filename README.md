# McGuire Asphalt Website

A professional Node.js Express application for an asphalt paving company website, featuring Google Maps integration and automated deployment.

## Project Structure
```
/var/www/app/               # Main application directory
├── app.js                  # Express application
├── package.json           # Node.js dependencies
├── Construction/          # Static website files
│   ├── assets/
│   │   ├── css/          # Stylesheets
│   │   ├── js/           # JavaScript files
│   │   └── img/          # Images
│   └── index.html        # Main HTML file
└── scripts/              # Deployment scripts
```

## Prerequisites

- Ubuntu Server (20.04 LTS or newer)
- Node.js v18+
- Nginx
- Domain name configured
- Git installed

## Initial Server Setup

### 1. Create Application Directory
```bash
# Create standard application directory
sudo mkdir -p /var/www/app
sudo useradd -r -m webapp
sudo chown -R webapp:webapp /var/www/app
sudo chmod -R 755 /var/www/app
```

### 2. Install Dependencies
```bash
# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt-get install -y nginx
```

### 3. Configure Nginx
```bash
# Create Nginx configuration
sudo nano /etc/nginx/sites-available/mywebsite.conf

# Create symbolic link
sudo ln -s /etc/nginx/sites-available/mywebsite.conf /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test and reload Nginx
sudo nginx -t
sudo systemctl reload nginx
```

Example Nginx configuration:
```nginx
server {
    listen 80;
    server_name yourdomain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Application Setup

### 1. Clone Repository
```bash
cd /var/www/app
git clone https://github.com/your-repo/asphalt-website.git .
npm install --omit=dev
```

### 2. Set Up User Service
```bash
# Create user service directory
mkdir -p ~/.config/systemd/user/

# Create service file
nano ~/.config/systemd/user/webapp.service
```

Service file content:
```ini
[Unit]
Description=Asphalt Website
After=network.target

[Service]
Type=simple
WorkingDirectory=/var/www/app
ExecStart=/usr/bin/node app.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=default.target
```

Enable the service:
```bash
systemctl --user enable webapp
systemctl --user start webapp
sudo loginctl enable-linger webapp
```

### 3. Google Maps Integration

1. Get Google Maps API key:
   - Visit Google Cloud Console
   - Create new project
   - Enable Maps JavaScript API
   - Create API key
   - Add domain restrictions

2. Update your API key in index.html:
```html
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap">
</script>
```

## Automated Deployment Setup

### 1. Create Deployment Script
```bash
# Create deployment script
sudo mkdir -p /var/www/app/scripts
sudo nano /var/www/app/scripts/deploy.sh
sudo chmod 755 /var/www/app/scripts/deploy.sh
```

Deploy script content:
```bash
#!/bin/bash

APP_DIR="/var/www/app"
LOG_FILE="/var/log/webapp-deploy.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

cd "$APP_DIR"

log_message "Starting deployment"
git pull origin main

log_message "Installing dependencies"
npm install --omit=dev

log_message "Restarting application"
systemctl --user restart webapp

log_message "Deployment completed"
```

### 2. GitHub Actions Setup

1. Generate deployment SSH key:
```bash
ssh-keygen -t ed25519 -C "deploy@yourdomain.com" -f ~/deploy-key
```

2. Add to GitHub:
   - Add public key to repository Deploy Keys
   - Add private key to repository Secrets as `DEPLOY_KEY`
   - Add server IP to Secrets as `SERVER_IP`

3. Create GitHub Actions workflow:
```bash
mkdir -p .github/workflows
nano .github/workflows/deploy.yml
```

Workflow content:
```yaml
name: Deploy to Production

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Setup SSH
        uses: shimataro/ssh-key-action@v2
        with:
          key: ${{ secrets.DEPLOY_KEY }}
          known_hosts: unnecessary
          if_key_exists: replace

      - name: Add known hosts
        run: |
          mkdir -p ~/.ssh
          ssh-keyscan -H ${{ secrets.SERVER_IP }} >> ~/.ssh/known_hosts

      - name: Deploy to server
        run: |
          ssh webapp@${{ secrets.SERVER_IP }} "export XDG_RUNTIME_DIR=/run/user/$(id -u) && bash /var/www/app/scripts/deploy.sh"
```

## Development

### Local Development
1. Clone repository
2. Install dependencies:
```bash
npm install
```
3. Start development server:
```bash
npm run dev
```

### Making Updates
1. Make changes locally
2. Commit and push to main branch
3. GitHub Actions will automatically deploy

## Maintenance

### Logs
- Application logs: `journalctl --user -u webapp`
- Deployment logs: `/var/log/webapp-deploy.log`
- Nginx logs: `/var/log/nginx/access.log` and `error.log`

### Common Commands
```bash
# Check application status
systemctl --user status webapp

# View logs
journalctl --user -u webapp -f

# Restart application
systemctl --user restart webapp

# Test Nginx configuration
sudo nginx -t
```

### SSL Certificate (Optional)
```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

## Troubleshooting

### Permission Issues
```bash
# Check ownership
ls -la /var/www/app

# Fix permissions
sudo chown -R webapp:webapp /var/www/app
sudo chmod -R 755 /var/www/app
```

### Deployment Issues
1. Check deploy logs:
```bash
cat /var/log/webapp-deploy.log
```

2. Verify SSH key setup:
```bash
ssh -i deploy-key -T git@github.com
```

### Service Issues
```bash
# Check service status
systemctl --user status webapp

# Check logs
journalctl --user -u webapp -f
```

## Security Notes

- Keep Node.js and npm packages updated
- Regularly update SSL certificates
- Monitor logs for unusual activity
- Keep Google Maps API key restricted
- Use strong SSH keys
- Regular system updates

## Support

For issues or questions:
1. Check application logs
2. Verify Nginx configuration
3. Check system resources
4. Review Google Maps console for API issues

## License
All rights reserved - Your Company Name 2024