const express = require('express');
const router = express.Router();
const { authenticateFirebaseToken } = require('../services/firebaseAdmin');
const { putInvoice, getInvoicesByUser, getInvoiceById } = require('../services/dynamoDbService');

// All invoice routes require verified Firebase Auth token
router.use(authenticateFirebaseToken);

/**
 * POST /invoices
 * Saves an invoice linked to the verified Firebase UID in DynamoDB
 */
router.post('/', async (req, res) => {
  try {
    const verifiedUid = req.user.uid;
    const body = req.body;

    if (!body || typeof body !== 'object') {
      return res.status(400).json({ error: 'Invalid Request', message: 'Invoice payload is required.' });
    }

    if (!body.invoiceNumber) {
      return res.status(400).json({ error: 'Validation Error', message: 'invoiceNumber is required.' });
    }

    // Auto-generate invoiceId if not supplied
    const invoiceId = body.invoiceId || `inv_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
    const invoiceData = {
      ...body,
      invoiceId,
    };

    const savedItem = await putInvoice(verifiedUid, invoiceData);

    return res.status(201).json({
      success: true,
      message: 'Invoice saved successfully to DynamoDB.',
      invoiceId: savedItem.invoiceId,
      invoiceNumber: savedItem.invoiceNumber,
      invoice: savedItem,
    });
  } catch (error) {
    console.error('Error saving invoice:', error);
    return res.status(500).json({
      error: 'Internal Server Error',
      message: 'Unable to save invoice. Please check your connection and try again.',
      details: error.message,
    });
  }
});

/**
 * GET /invoices
 * Retrieves all invoices for the authenticated Firebase user
 */
router.get('/', async (req, res) => {
  try {
    const verifiedUid = req.user.uid;
    const invoices = await getInvoicesByUser(verifiedUid);

    return res.status(200).json({
      success: true,
      count: invoices.length,
      userId: verifiedUid,
      invoices,
    });
  } catch (error) {
    console.error('Error fetching invoices:', error);
    return res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve invoices from DynamoDB.',
      details: error.message,
    });
  }
});

/**
 * GET /invoices/:invoiceId
 * Retrieves a specific invoice ensuring it belongs to the authenticated Firebase user
 */
router.get('/:invoiceId', async (req, res) => {
  try {
    const verifiedUid = req.user.uid;
    const { invoiceId } = req.params;

    const invoice = await getInvoiceById(verifiedUid, invoiceId);

    if (!invoice) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Invoice '${invoiceId}' not found for authenticated user.`,
      });
    }

    return res.status(200).json({
      success: true,
      invoice,
    });
  } catch (error) {
    console.error('Error fetching single invoice:', error);
    return res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve invoice from DynamoDB.',
      details: error.message,
    });
  }
});

module.exports = router;
