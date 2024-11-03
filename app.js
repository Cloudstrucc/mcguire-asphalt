const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// //Updated CSP configuration to allow Google Maps and CDN resources
app.use(helmet({
    contentSecurityPolicy: {
        useDefaults: false,
        directives: {
            defaultSrc: ["'self'"],
            scriptSrc: [
                "'self'",
                "'unsafe-inline'",
                "'unsafe-eval'",
                "https://maps.googleapis.com",
                "https://*.googleapis.com",
                "https://cdnjs.cloudflare.com",
                "https://*.gstatic.com"
            ],
            scriptSrcAttr: ["'unsafe-inline'"],
            styleSrc: [
                "'self'",
                "'unsafe-inline'",
                "https://fonts.googleapis.com",
                "https://cdnjs.cloudflare.com"
            ],
            imgSrc: [
                "'self'",
                "data:",
                "https://*.googleapis.com",
                "https://*.gstatic.com",
                "https://*.google.com",
                "https://*.ggpht.com"
            ],
            connectSrc: [
                "'self'",
                "https://*.googleapis.com",
                "https://maps.googleapis.com"
            ],
            fontSrc: [
                "'self'",
                "https://fonts.gstatic.com",
                "https://cdnjs.cloudflare.com"
            ],
            frameSrc: ["'self'", "https://www.google.com"],
            objectSrc: ["'none'"],
            mediaSrc: ["'none'"],
            childSrc: ["blob:"]
        }
    },
    crossOriginEmbedderPolicy: false,
    crossOriginResourcePolicy: false
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
