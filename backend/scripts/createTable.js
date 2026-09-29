require('dotenv').config();
const { DynamoDBClient, CreateTableCommand, DescribeTableCommand } = require('@aws-sdk/client-dynamodb');

const REGION = process.env.AWS_REGION || 'ap-south-1';
const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME || 'SmartGSTInvoices';

async function main() {
  console.log(`Checking DynamoDB table "${TABLE_NAME}" in region ${REGION}...`);

  const client = new DynamoDBClient({
    region: REGION,
    credentials: (process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) ? {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    } : undefined,
  });

  try {
    const desc = await client.send(new DescribeTableCommand({ TableName: TABLE_NAME }));
    console.log(`✅ Table "${TABLE_NAME}" already exists. Status: ${desc.Table.TableStatus}`);
    return;
  } catch (err) {
    if (err.name !== 'ResourceNotFoundException') {
      console.error('Error describing table:', err);
      process.exit(1);
    }
  }

  console.log(`Creating table "${TABLE_NAME}" with Partition Key: userId (S), Sort Key: invoiceId (S)...`);

  const cmd = new CreateTableCommand({
    TableName: TABLE_NAME,
    KeySchema: [
      { AttributeName: 'userId', KeyType: 'HASH' },
      { AttributeName: 'invoiceId', KeyType: 'RANGE' },
    ],
    AttributeDefinitions: [
      { AttributeName: 'userId', AttributeType: 'S' },
      { AttributeName: 'invoiceId', AttributeType: 'S' },
    ],
    BillingMode: 'PAY_PER_REQUEST',
  });

  try {
    const res = await client.send(cmd);
    console.log(`✅ Table "${TABLE_NAME}" created successfully! Status: ${res.TableDescription.TableStatus}`);
  } catch (err) {
    console.error('Failed to create DynamoDB table:', err.message);
    process.exit(1);
  }
}

main();
