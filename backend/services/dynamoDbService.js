const { DynamoDBClient, CreateTableCommand, DescribeTableCommand } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, QueryCommand, GetCommand } = require('@aws-sdk/lib-dynamodb');
const fs = require('fs');
const path = require('path');

const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME || 'SmartGSTInvoices';
const REGION = process.env.AWS_REGION || 'ap-south-1';

let ddbDocClient = null;
let isAwsAvailable = false;

// Local fallback storage file to guarantee resilience during offline test runs
const LOCAL_STORAGE_DIR = path.join(__dirname, '../data');
const LOCAL_STORAGE_FILE = path.join(LOCAL_STORAGE_DIR, 'dynamodb_invoices.json');

function ensureLocalStorage() {
  if (!fs.existsSync(LOCAL_STORAGE_DIR)) {
    fs.mkdirSync(LOCAL_STORAGE_DIR, { recursive: true });
  }
  if (!fs.existsSync(LOCAL_STORAGE_FILE)) {
    fs.writeFileSync(LOCAL_STORAGE_FILE, JSON.stringify({}), 'utf8');
  }
}

function getLocalInvoices(userId) {
  ensureLocalStorage();
  try {
    const raw = fs.readFileSync(LOCAL_STORAGE_FILE, 'utf8');
    const data = JSON.parse(raw);
    const userInvoices = data[userId] || [];
    return userInvoices;
  } catch (e) {
    console.error('Local storage read error:', e);
    return [];
  }
}

function saveLocalInvoice(userId, invoice) {
  ensureLocalStorage();
  try {
    const raw = fs.readFileSync(LOCAL_STORAGE_FILE, 'utf8');
    const data = JSON.parse(raw);
    if (!data[userId]) {
      data[userId] = [];
    }
    const idx = data[userId].findIndex(i => i.invoiceId === invoice.invoiceId);
    if (idx !== -1) {
      data[userId][idx] = invoice;
    } else {
      data[userId].unshift(invoice);
    }
    fs.writeFileSync(LOCAL_STORAGE_FILE, JSON.stringify(data, null, 2), 'utf8');
  } catch (e) {
    console.error('Local storage write error:', e);
  }
}

function initDynamoDB() {
  try {
    const clientConfig = { region: REGION };

    // Support custom DynamoDB Local endpoint if provided
    if (process.env.DYNAMODB_ENDPOINT) {
      clientConfig.endpoint = process.env.DYNAMODB_ENDPOINT;
    }

    if (process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) {
      clientConfig.credentials = {
        accessKeyId: process.env.AWS_ACCESS_KEY_ID,
        secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
      };
      isAwsAvailable = true;
    } else if (process.env.DYNAMODB_ENDPOINT) {
      clientConfig.credentials = {
        accessKeyId: 'fakeLocalKey',
        secretAccessKey: 'fakeLocalSecret',
      };
      isAwsAvailable = true;
    }

    const rawClient = new DynamoDBClient(clientConfig);
    ddbDocClient = DynamoDBDocumentClient.from(rawClient, {
      marshallOptions: { removeUndefinedValues: true },
    });

    console.log(`✅ DynamoDB Client initialized for table: ${TABLE_NAME} in ${REGION}`);
  } catch (err) {
    console.warn('⚠️ DynamoDB client initialization notice:', err.message);
  }
}

initDynamoDB();

/**
 * Ensures the SmartGSTInvoices table exists in DynamoDB
 */
async function createTableIfNotExists() {
  if (!ddbDocClient) return false;
  try {
    const rawClient = new DynamoDBClient({ region: REGION });
    try {
      await rawClient.send(new DescribeTableCommand({ TableName: TABLE_NAME }));
      console.log(`Table ${TABLE_NAME} already exists.`);
      return true;
    } catch (e) {
      if (e.name === 'ResourceNotFoundException') {
        console.log(`Creating DynamoDB table: ${TABLE_NAME}...`);
        await rawClient.send(new CreateTableCommand({
          TableName: TABLE_NAME,
          KeySchema: [
            { AttributeName: 'userId', KeyType: 'HASH' },  // Partition Key
            { AttributeName: 'invoiceId', KeyType: 'RANGE' }, // Sort Key
          ],
          AttributeDefinitions: [
            { AttributeName: 'userId', AttributeType: 'S' },
            { AttributeName: 'invoiceId', AttributeType: 'S' },
          ],
          BillingMode: 'PAY_PER_REQUEST',
        }));
        console.log(`✅ Table ${TABLE_NAME} created successfully.`);
        return true;
      }
      throw e;
    }
  } catch (e) {
    console.warn('DynamoDB table check/creation notice:', e.message);
    return false;
  }
}

/**
 * Phase 8 / 9: Save Invoice to DynamoDB
 * Partition key: userId (String)
 * Sort key: invoiceId (String)
 */
async function putInvoice(userId, invoiceData) {
  const item = {
    userId,
    invoiceId: invoiceData.invoiceId,
    invoiceNumber: invoiceData.invoiceNumber,
    customerId: invoiceData.customerId || '',
    customerName: invoiceData.customerName || 'Walk-in Customer',
    customerPhone: invoiceData.customerPhone || '',
    customerAddress: invoiceData.customerAddress || '',
    customerGstin: invoiceData.customerGstin || '',
    customerState: invoiceData.customerState || '',
    items: invoiceData.items || [],
    subtotal: Number(invoiceData.subtotal || 0),
    discountAmount: Number(invoiceData.discountAmount || 0),
    discountPercent: Number(invoiceData.discountPercent || 0),
    taxableAmount: Number(invoiceData.taxableAmount || invoiceData.subtotal || 0),
    cgst: Number(invoiceData.cgst || 0),
    sgst: Number(invoiceData.sgst || 0),
    igst: Number(invoiceData.igst || 0),
    gstTotal: Number(invoiceData.gstTotal || 0),
    grandTotal: Number(invoiceData.grandTotal || 0),
    paymentMethod: invoiceData.paymentMethod || 'cash',
    paymentStatus: invoiceData.paymentStatus || 'COMPLETED',
    amountPaid: Number(invoiceData.amountPaid || invoiceData.grandTotal || 0),
    changeReturned: Number(invoiceData.changeReturned || 0),
    cashierId: invoiceData.cashierId || '',
    cashierName: invoiceData.cashierName || 'Admin',
    notes: invoiceData.notes || '',
    isInterState: Boolean(invoiceData.isInterState),
    isCancelled: Boolean(invoiceData.isCancelled),
    status: invoiceData.status || 'COMPLETED',
    createdAt: invoiceData.createdAt || new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  // 1. Always save to local persistence layer for zero data loss
  saveLocalInvoice(userId, item);

  // 2. If AWS DynamoDB is configured, write to cloud DynamoDB
  if (ddbDocClient && isAwsAvailable) {
    try {
      await ddbDocClient.send(new PutCommand({
        TableName: TABLE_NAME,
        Item: item,
      }));
      console.log(`✅ Invoice ${item.invoiceNumber} written to DynamoDB for user ${userId}`);
    } catch (awsError) {
      console.warn(`AWS DynamoDB PutItem notice: ${awsError.message}. Item preserved in local persistence layer.`);
    }
  }

  return item;
}

/**
 * Phase 8 / 9: Get all invoices for verified UID
 */
async function getInvoicesByUser(userId) {
  // If AWS DynamoDB is configured and online, query DynamoDB
  if (ddbDocClient && isAwsAvailable) {
    try {
      const result = await ddbDocClient.send(new QueryCommand({
        TableName: TABLE_NAME,
        KeyConditionExpression: 'userId = :uid',
        ExpressionAttributeValues: {
          ':uid': userId,
        },
        ScanIndexForward: false, // newest first
      }));

      if (result.Items && result.Items.length > 0) {
        return result.Items;
      }
    } catch (awsError) {
      console.warn(`AWS DynamoDB Query notice: ${awsError.message}. Fetching from local persistence store.`);
    }
  }

  // Fallback to local persistence
  return getLocalInvoices(userId);
}

/**
 * Phase 8 / 9: Get single invoice for verified UID
 */
async function getInvoiceById(userId, invoiceId) {
  if (ddbDocClient && isAwsAvailable) {
    try {
      const result = await ddbDocClient.send(new GetCommand({
        TableName: TABLE_NAME,
        Key: {
          userId,
          invoiceId,
        },
      }));
      if (result.Item) {
        return result.Item;
      }
    } catch (awsError) {
      console.warn(`AWS DynamoDB GetItem notice: ${awsError.message}`);
    }
  }

  const invoices = getLocalInvoices(userId);
  return invoices.find(i => i.invoiceId === invoiceId) || null;
}

module.exports = {
  TABLE_NAME,
  putInvoice,
  getInvoicesByUser,
  getInvoiceById,
  createTableIfNotExists,
  initDynamoDB,
};
