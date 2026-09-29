# AWS DynamoDB Setup Guide — SMART GST POS

## 1. Overview
**SMART GST POS** uses **Amazon DynamoDB** as its enterprise-grade NoSQL cloud database. All invoices generated at checkout are persisted to DynamoDB partitioned by the authenticated user's Firebase UID.

---

## 2. Table Design: `SmartGSTInvoices`

| Attribute | DynamoDB Key Type | Data Type | Description |
|---|---|---|---|
| `userId` | **Partition Key (HASH)** | `String (S)` | The verified Firebase UID of the account owner |
| `invoiceId` | **Sort Key (RANGE)** | `String (S)` | Unique invoice identifier (`inv_<timestamp>_<id>`) |

### Item Attributes Stored:
* `userId` (String): Partition key scoping data to each user
* `invoiceId` (String): Sort key
* `invoiceNumber` (String): e.g., `INV-2026-0001`
* `customerId` (String): Customer reference
* `customerName` (String): Customer display name
* `customerPhone` (String): Phone number
* `customerAddress` (String): Customer billing address
* `customerGstin` (String): Customer GST Identification Number
* `customerState` (String): Customer state (e.g., `Maharashtra`)
* `items` (List of Map): Array of line items with `productName`, `quantity`, `unitPrice`, `gstRate`, `gstAmount`, `taxableAmount`, `totalAmount`
* `subtotal` (Number): Taxable amount before GST
* `discountAmount` (Number): Flat + percentage discount in rupees
* `discountPercent` (Number): Discount percentage
* `taxableAmount` (Number): Net taxable total
* `cgst` (Number): Central GST component
* `sgst` (Number): State GST component
* `igst` (Number): Integrated GST component (inter-state)
* `gstTotal` (Number): Total GST tax amount
* `grandTotal` (Number): Final bill amount inclusive of GST
* `paymentMethod` (String): `cash`, `upi`, `card`, `credit`
* `paymentStatus` (String): `COMPLETED`, `CREDIT`, `CANCELLED`
* `amountPaid` (Number): Amount received from customer
* `changeReturned` (Number): Change returned to customer
* `cashierId` (String): Staff ID or Firebase UID
* `cashierName` (String): Staff or Owner name
* `notes` (String): Invoice remarks
* `isInterState` (Boolean): `true` if supply is inter-state
* `isCancelled` (Boolean): `true` if invoice was voided
* `status` (String): `COMPLETED` / `CANCELLED`
* `createdAt` (String): ISO 8601 server timestamp
* `updatedAt` (String): ISO 8601 update timestamp

---

## 3. Provisioning the Table via Script

To automatically create the table in your AWS account, run:

```bash
cd backend
npm install
node scripts/createTable.js
```

Or using AWS CLI:
```bash
aws dynamodb create-table \
    --table-name SmartGSTInvoices \
    --attribute-definitions \
        AttributeName=userId,AttributeType=S \
        AttributeName=invoiceId,AttributeType=S \
    --key-schema \
        AttributeName=userId,KeyType=HASH \
        AttributeName=invoiceId,KeyType=RANGE \
    --billing-mode PAY_PER_REQUEST \
    --region ap-south-1
```

---

## 4. Multi-Tenant User Isolation
Because the Partition Key is `userId`:
* When querying invoices (`GET /invoices`), DynamoDB executes a `Query` with `KeyConditionExpression: 'userId = :uid'`.
* It is mathematically and architecturally impossible for User A to retrieve or overwrite User B's invoices.
