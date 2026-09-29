#!/usr/bin/env python3
import json
import urllib.request
import urllib.error
import subprocess
import time
import sys
import os

PORT = 3001
BASE_URL = f"http://localhost:{PORT}"

def request(method, path, body=None, headers=None):
    if headers is None:
        headers = {}
    headers["Content-Type"] = "application/json"
    url = f"{BASE_URL}{path}"
    data = json.dumps(body).encode("utf-8") if body else None
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            content = resp.read().decode("utf-8")
            return resp.status, json.loads(content)
    except urllib.error.HTTPError as e:
        content = e.read().decode("utf-8")
        try:
            return e.code, json.loads(content)
        except Exception:
            return e.code, content

def run_tests():
    print("=== RUNNING BACKEND & DYNAMODB API TESTS ===")
    
    env = os.environ.copy()
    env["PORT"] = str(PORT)
    proc = subprocess.Popen([sys.executable, "server.py"], cwd=os.path.join(os.path.dirname(__file__)), env=env)
    time.sleep(1)

    try:
        # 1. Health check
        print("1. Testing GET /health...")
        status, res = request("GET", "/health")
        assert status == 200, f"Expected 200, got {status}"
        assert res["status"] == "healthy"
        print("   ✓ GET /health is healthy")

        # 2. Unauthorized request test
        print("2. Testing unauthorized GET /invoices...")
        status, res = request("GET", "/invoices")
        assert status == 401, f"Expected 401, got {status}"
        print("   ✓ Unauthorized access blocked (401)")

        # 3. User A: Create invoice
        print("3. Testing POST /invoices for User A...")
        token_a = "Bearer demo_token_user_a_123"
        invoice_a = {
            "invoiceNumber": "INV-A-001",
            "customerName": "Ramesh Kumar",
            "customerPhone": "9876543210",
            "grandTotal": 1050.0,
            "subtotal": 1000.0,
            "totalGst": 50.0,
            "paymentMethod": "cash",
            "items": [{"productId": "p1", "productName": "Tea 1kg", "quantity": 2, "totalAmount": 1000.0}]
        }
        status, res = request("POST", "/invoices", body=invoice_a, headers={"Authorization": token_a})
        assert status == 201, f"Expected 201, got {status}: {res}"
        assert res["success"] is True
        assert res["invoiceNumber"] == "INV-A-001"
        invoice_a_id = res["invoiceId"]
        print(f"   ✓ User A invoice created with ID: {invoice_a_id}")

        # 4. User A: Retrieve Invoices
        print("4. Testing GET /invoices for User A...")
        status, res = request("GET", "/invoices", headers={"Authorization": token_a})
        assert status == 200
        assert len(res["invoices"]) >= 1
        assert res["invoices"][0]["invoiceNumber"] == "INV-A-001"
        print("   ✓ User A retrieved their invoices")

        # 5. User Isolation: User B cannot see User A's invoice
        print("5. Testing User Isolation (User B cannot see User A data)...")
        token_b = "Bearer demo_token_user_b_456"
        status, res = request("GET", "/invoices", headers={"Authorization": token_b})
        assert status == 200
        user_b_has_a = any(i.get("invoiceNumber") == "INV-A-001" for i in res["invoices"])
        assert not user_b_has_a, "User B saw User A's invoice! Isolation violation."
        print("   ✓ User Isolation verified: User B cannot see User A's invoices")

        # 6. User B creates their own invoice
        print("6. Testing POST /invoices for User B...")
        invoice_b = {
            "invoiceNumber": "INV-B-001",
            "customerName": "Suresh Raina",
            "grandTotal": 2100.0,
            "paymentMethod": "upi",
            "items": []
        }
        status, res = request("POST", "/invoices", body=invoice_b, headers={"Authorization": token_b})
        assert status == 201
        assert res["invoiceNumber"] == "INV-B-001"
        print("   ✓ User B invoice created: INV-B-001")

        # 7. Cross-user direct fetch blocked
        print("7. Testing cross-user direct invoice access...")
        status, res = request("GET", f"/invoices/{invoice_a_id}", headers={"Authorization": token_b})
        assert status == 404, f"Expected 404 for User B trying to access User A's invoice, got {status}"
        print("   ✓ Cross-user invoice fetch blocked (404 Not Found)")

        print("\n🎉 ALL 7 BACKEND TESTS PASSED CLEANLY!\n")
    finally:
        proc.terminate()

if __name__ == "__main__":
    run_tests()
