const assert = require('assert');
const http = require('http');
const app = require('../server');

let server;
const PORT = 3099;
const BASE_URL = `http://localhost:${PORT}`;

function makeRequest(method, path, body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const options = {
      method,
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        let json = null;
        try {
          json = JSON.parse(data);
        } catch (_) {
          json = data;
        }
        resolve({ statusCode: res.statusCode, data: json });
      });
    });

    req.on('error', reject);
    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function runTests() {
  console.log('--- Starting Cloud Backend & DynamoDB Isolation Tests ---');

  server = app.listen(PORT);

  try {
    // 1. Health Check Test
    console.log('1. Testing /health endpoint...');
    const health = await makeRequest('GET', '/health');
    assert.strictEqual(health.statusCode, 200);
    assert.strictEqual(health.data.status, 'healthy');
    console.log('   ✓ Health check passed');

    // 2. Unauthorized request test (Missing Token)
    console.log('2. Testing missing authorization header...');
    const unauth = await makeRequest('GET', '/invoices');
    assert.strictEqual(unauth.statusCode, 401);
    console.log('   ✓ Unauthorized access blocked');

    // 3. User A: Create Invoice
    console.log('3. Testing User A invoice creation (POST /invoices)...');
    const userAToken = 'demo_token_user_a_uid';
    const invoiceA = {
      invoiceId: 'inv_user_a_001',
      invoiceNumber: 'INV-A-001',
      customerName: 'User A Customer',
      customerPhone: '9800000001',
      grandTotal: 1500.0,
      subtotal: 1400.0,
      gstTotal: 100.0,
      cgst: 50.0,
      sgst: 50.0,
      items: [
        { productName: 'Item A', quantity: 2, unitPrice: 700.0, totalAmount: 1400.0 }
      ],
      paymentMethod: 'cash',
    };

    const postResA = await makeRequest('POST', '/invoices', invoiceA, {
      'Authorization': `Bearer ${userAToken}`,
    });

    assert.strictEqual(postResA.statusCode, 201);
    assert.strictEqual(postResA.data.success, true);
    assert.strictEqual(postResA.data.invoiceNumber, 'INV-A-001');
    console.log('   ✓ User A invoice created successfully');

    // 4. User A: Fetch Invoices
    console.log('4. Testing User A invoices retrieval (GET /invoices)...');
    const getResA = await makeRequest('GET', '/invoices', null, {
      'Authorization': `Bearer ${userAToken}`,
    });
    assert.strictEqual(getResA.statusCode, 200);
    assert.strictEqual(getResA.data.success, true);
    assert(getResA.data.invoices.length >= 1);
    assert.strictEqual(getResA.data.invoices[0].invoiceNumber, 'INV-A-001');
    console.log('   ✓ User A fetched their invoice');

    // 5. User B: User Isolation Test (Must NOT see User A's invoices)
    console.log('5. Testing User Isolation (User B cannot see User A data)...');
    const userBToken = 'demo_token_user_b_uid';
    const getResB = await makeRequest('GET', '/invoices', null, {
      'Authorization': `Bearer ${userBToken}`,
    });
    assert.strictEqual(getResB.statusCode, 200);
    // User B must have 0 invoices initially or only User B invoices
    const hasUserAInvoice = (getResB.data.invoices || []).some(i => i.invoiceNumber === 'INV-A-001');
    assert.strictEqual(hasUserAInvoice, false, 'User B must NOT see User A invoice!');
    console.log('   ✓ User Isolation verified: User B cannot see User A invoices');

    // 6. User B creates invoice B
    console.log('6. Testing User B invoice creation...');
    const invoiceB = {
      invoiceId: 'inv_user_b_001',
      invoiceNumber: 'INV-B-001',
      customerName: 'User B Customer',
      grandTotal: 2500.0,
      subtotal: 2300.0,
      gstTotal: 200.0,
      items: [],
      paymentMethod: 'upi',
    };
    const postResB = await makeRequest('POST', '/invoices', invoiceB, {
      'Authorization': `Bearer ${userBToken}`,
    });
    assert.strictEqual(postResB.statusCode, 201);
    assert.strictEqual(postResB.data.invoiceNumber, 'INV-B-001');
    console.log('   ✓ User B invoice created');

    // 7. User A attempts to fetch User B's invoice directly (GET /invoices/inv_user_b_001)
    console.log('7. Testing direct single-item cross-user access block...');
    const crossAccessRes = await makeRequest('GET', '/invoices/inv_user_b_001', null, {
      'Authorization': `Bearer ${userAToken}`,
    });
    assert.strictEqual(crossAccessRes.statusCode, 404, 'User A cannot access User B invoice directly');
    console.log('   ✓ Cross-user single invoice fetch blocked (404 Not Found)');

    console.log('\n🎉 ALL 7 BACKEND & DYNAMODB API TESTS PASSED SUCCESSFULLY!\n');
  } finally {
    server.close();
  }
}

runTests().catch((err) => {
  console.error('❌ Test failed:', err);
  if (server) server.close();
  process.exit(1);
});
