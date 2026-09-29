require('dotenv').config();
const express = require('express');
const cors = require('cors');
const invoiceRoutes = require('./routes/invoices');
const { createTableIfNotExists } = require('./services/dynamoDbService');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for Flutter Web (localhost:8080, localhost:*, etc.) and mobile/desktop clients
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Fallback-UID'],
}));

app.use(express.json({ limit: '10mb' }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'SMART GST POS Cloud API',
    database: 'AWS DynamoDB (SmartGSTInvoices)',
  });
});

// Mount invoice routes
app.use('/invoices', invoiceRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.url} does not exist on this server.`,
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Unhandled server error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message,
  });
});

// Start server if not running inside Lambda
if (require.main === module) {
  app.listen(PORT, async () => {
    console.log(`🚀 SMART GST Cloud Backend running at http://localhost:${PORT}`);
    console.log(`📦 DynamoDB Invoices API: http://localhost:${PORT}/invoices`);
    console.log(`🩺 Health check: http://localhost:${PORT}/health`);

    // Attempt table verification
    try {
      await createTableIfNotExists();
    } catch (_) {}
  });
}

module.exports = app;
