# McGuire Asphalt Website Project

## Overview
This project is a Node.js Express application serving a professional website for McGuire Asphalt, featuring a custom Bootstrap template with Google Maps integration.

## Prerequisites
- Ubuntu Server (20.04 LTS or newer)
- Node.js v18+
- Nginx
- Domain name configured (asphalt.cloudstrucc.com)

## Server Setup

### 1. Initial Server Configuration
```bash
# Create and run the server setup script
sudo nano server-setup.sh
sudo chmod +x server-setup.sh
sudo ./server-setup.sh
```

The script will:
- Create a new sudo user
- Configure SSH security
- Set up firewall rules
- Install Nginx
- Configure SSL with Let's Encrypt

### 2. Website Deployment

#### Create Application Directory
```bash
sudo mkdir -p /var/www/asphalt
sudo chown -R fredp614:fredp614 /var/www/asphalt
sudo chmod -R 755 /var/www/asphalt
```

#### Clone Repository and Deploy
```bash
cd /var/www/asphalt
git clone https://github.com/Cloudstrucc/mcguire-asphalt.git .
```

#### Set Up Google Maps
1. Set up Google Maps API:
   - Visit Google Cloud Console
   - Create/Select project
   - Enable Maps JavaScript API
   - Create API key with restrictions
   - Add domain restrictions for asphalt.cloudstrucc.com

2. Current API Key: `AIzaSyA2HJk1J8qN94Tvq1hH347LSMA1KZykNtU`

### 3. Content Updates

#### Update Images
```bash
# Navigate to images directory
cd /var/www/asphalt/Construction/assets/img

# Download banner images
sudo wget https://images.unsplash.com/photo-1589939705384-5185137a7f0f -O asphalt-worker.jpg
sudo wget https://images.unsplash.com/photo-1518709766631-a6a7f45921c3 -O asphalt-hero.jpg

# Set permissions
sudo chmod 644 asphalt-worker.jpg asphalt-hero.jpg
sudo chown www-data:www-data asphalt-worker.jpg asphalt-hero.jpg
```

#### Update CSS
```bash
# Edit main CSS file
sudo nano /var/www/asphalt/Construction/assets/css/main.css
```
Add banner section styles at the end of the file for:
- Hero image configuration
- Typography updates
- Responsive design
- Button styling

## Application Structure
```
/var/www/asphalt/
├── app.js                 # Express application
├── package.json          # Node.js dependencies
├── Construction/         # Static website files
│   ├── index.html       # Main HTML file
│   ├── assets/
│   │   ├── css/        # CSS files
│   │   ├── js/         # JavaScript files
│   │   └── img/        # Image files
```

## Key Files
- `app.js`: Express application with CSP configuration
- `Construction/index.html`: Main website template
- `Construction/assets/js/site.js`: Custom JavaScript including Google Maps
- `Construction/assets/css/main.css`: Custom styling

## Running the Application

### Start the Application
```bash
# Start/restart the application
sudo systemctl restart asphalt

# Check status
sudo systemctl status asphalt
```

### View Logs
```bash
# View application logs
sudo journalctl -u asphalt -f

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Maintenance

### Update Website Content
1. Push changes to GitHub
2. Pull changes on server:
```bash
cd /var/www/asphalt
git pull origin main
sudo systemctl restart asphalt
```

### SSL Certificate
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate
sudo certbot renew --dry-run
```

## Troubleshooting

### Common Issues
1. Permission Issues:
```bash
sudo chown -R fredp614:fredp614 /var/www/asphalt
sudo chmod -R 755 /var/www/asphalt
```

2. Nginx Configuration:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

3. Application Not Starting:
```bash
sudo systemctl status asphalt
sudo journalctl -u asphalt -f
```

### Security Notes
- Keep Node.js and npm packages updated
- Regularly update SSL certificates
- Monitor server logs for unusual activity
- Keep Google Maps API key restricted
- Regular system updates

## Development

### Local Development
1. Clone repository
2. Install dependencies: `npm install`
3. Start development server: `npm start`

### Deployment
1. Push changes to GitHub
2. SSH into server
3. Pull changes and restart application

## Support
For issues or questions:
1. Check application logs
2. Verify Nginx configuration
3. Check system resources
4. Review Google Maps console for API issues

## License
All rights reserved - McGuire Asphalt 2024