# McGuire Asphalt Website Deployment Guide

This guide covers the complete process of setting up an Ubuntu server and deploying the McGuire Asphalt website, from initial server configuration to final deployment.

## Table of Contents

- [Initial Server Setup](#initial-server-setup)
- [Web Server Configuration](#web-server-configuration)
- [Website Deployment](#website-deployment)
- [Maintenance and Monitoring](#maintenance-and-monitoring)
- [Troubleshooting](#troubleshooting)

## Initial Server Setup

### 1. Basic Server Configuration

First, run the server setup script to configure basic security and requirements:

```bash
# Create the setup script
sudo nano server-setup.sh

# Make it executable
sudo chmod +x server-setup.sh

# Run the script
sudo ./server-setup.sh
```

The script will:

- Create a new sudo user
- Configure SSH security
- Set up firewall rules
- Install Nginx
- Configure SSL with Let's Encrypt

When prompted, provide:

- New username
- Domain name (asphalt.cloudstrucc.com)
- Whether to include www subdomain

### 2. Update System Packages

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 3. Install Required Software

```bash
# Install Git
sudo apt-get install git -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install nodejs -y
```

## Web Server Configuration

### 1. Set Up Website Directory

```bash
# Create application directory
sudo mkdir -p /home/fredp614/asphalt-app

# Set ownership
sudo chown fredp614:fredp614 /home/fredp614/asphalt-app

# Set permissions
sudo chmod 755 /home/fredp614/asphalt-app
```

### 2. Configure Nginx

The server setup script will handle this, but you can verify the configuration:

```bash
sudo nginx -t
sudo systemctl status nginx
```

## Website Deployment

### 1. Create Deployment Script

```bash
# Create deployment script
sudo nano ~/deploy-asphalt.sh

# Make it executable
sudo chmod +x ~/deploy-asphalt.sh
```

### 2. Run Deployment

```bash
sudo ./deploy-asphalt.sh
```

The deployment script will:

- Clone the GitHub repository (https://github.com/Cloudstrucc/mcguire-asphalt)
- Set up the Node.js application
- Configure the systemd service
- Set up Nginx reverse proxy
- Start the application

### 3. Verify Deployment

```bash
# Check Node.js application status
sudo systemctl status asphalt

# Check Nginx status
sudo systemctl status nginx

# View application logs
sudo journalctl -u asphalt -f
```

## Directory Structure

After deployment, your files will be organized as follows:

/home/fredp614/asphalt-app/
├── app.js
├── package.json
├── package-lock.json
├── node_modules/
└── Construction/
    ├── index.html
    ├── assets/
    └── ...

## Maintenance and Monitoring

### Updating the Website

To update the website with new changes:

1. Push changes to the GitHub repository
2. Run the deployment script again:

```bash
sudo ./deploy-asphalt.sh
```

### Monitoring

Monitor the application using these commands:

```bash
# View real-time application logs
sudo journalctl -u asphalt -f

# Check application status
sudo systemctl status asphalt

# Check Nginx status
sudo systemctl status nginx
```

### Common Commands

```bash
# Restart the application
sudo systemctl restart asphalt

# Restart Nginx
sudo systemctl restart nginx

# View recent logs
sudo journalctl -u asphalt --since "1 hour ago"
```

## Troubleshooting

### Permission Issues

If you encounter permission denied errors:

```bash
# Check directory ownership
ls -la /home/fredp614/asphalt-app

# Fix permissions if needed
sudo chown -R fredp614:fredp614 /home/fredp614/asphalt-app
sudo chmod -R 755 /home/fredp614/asphalt-app
```

### Application Won't Start

1. Check logs for errors:

```bash
sudo journalctl -u asphalt -f
```

2. Verify Node.js installation:

```bash
node --version
npm --version
```

3. Check if port 3000 is in use:

```bash
sudo lsof -i :3000
```

### Nginx Issues

1. Test configuration:

```bash
sudo nginx -t
```

2. Check error logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

### SSL Certificate Issues

If SSL certificate isn't working:

```bash
# Check certificate status
sudo certbot certificates

# Renew certificate
sudo certbot renew --dry-run
```

## Security Notes

1. Regular Updates

```bash
# Update system packages
sudo apt-get update && sudo apt-get upgrade

# Update npm packages
cd /home/fredp614/asphalt-app
npm update
```

2. Monitor Logs

```bash
# Check authentication logs
sudo tail -f /var/log/auth.log

# Check Nginx access logs
sudo tail -f /var/log/nginx/access.log
```

## Support

For issues:

1. Check application logs
2. Verify Nginx configuration
3. Ensure all services are running
4. Check system resources

## File Locations

Important file locations:

- Node.js Application: `/home/fredp614/asphalt-app`
- Nginx Config: `/etc/nginx/sites-available/asphalt.cloudstrucc.com`
- SSL Certificates: `/etc/letsencrypt/live/asphalt.cloudstrucc.com/`
- Application Logs: `journalctl -u asphalt`
- Nginx Logs: `/var/log/nginx/`

## Additional Notes

- Keep backup copies of important configuration files
- Regularly update SSL certificates
- Monitor server resources
- Keep the GitHub repository up to date
- Maintain regular backups of the website content
