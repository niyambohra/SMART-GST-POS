-- ==============================================================================
-- UNIBILLS GST POS — Supabase PostgreSQL Database Schema & RLS Policies
-- Migration: 001_initial_pos_schema.sql
-- ==============================================================================

-- 1. PROFILES TABLE (Stores user metadata linked to Firebase UID)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  firebase_uid TEXT UNIQUE NOT NULL,
  email TEXT NOT NULL,
  full_name TEXT NOT NULL DEFAULT 'Store Owner',
  role TEXT NOT NULL DEFAULT 'owner',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS public.products (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  barcode TEXT NOT NULL DEFAULT '',
  hsn_code TEXT NOT NULL DEFAULT '',
  price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  gst_rate NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  category TEXT NOT NULL DEFAULT 'General',
  unit TEXT NOT NULL DEFAULT 'Pcs',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS public.customers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  phone TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL DEFAULT '',
  address TEXT NOT NULL DEFAULT '',
  gstin TEXT NOT NULL DEFAULT '',
  state TEXT NOT NULL DEFAULT 'Maharashtra',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. INVOICES TABLE
CREATE TABLE IF NOT EXISTS public.invoices (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  invoice_number TEXT NOT NULL,
  customer_id TEXT NOT NULL DEFAULT '',
  customer_name TEXT NOT NULL DEFAULT 'Walk-in Customer',
  customer_phone TEXT NOT NULL DEFAULT '',
  customer_address TEXT NOT NULL DEFAULT '',
  customer_gstin TEXT NOT NULL DEFAULT '',
  customer_state TEXT NOT NULL DEFAULT 'Maharashtra',
  invoice_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  discount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
  taxable_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  cgst NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  sgst NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  igst NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  gst_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  payment_method TEXT NOT NULL DEFAULT 'cash',
  payment_status TEXT NOT NULL DEFAULT 'COMPLETED',
  amount_paid NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  change_returned NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  cashier_name TEXT NOT NULL DEFAULT 'Admin',
  cashier_id TEXT NOT NULL DEFAULT '',
  notes TEXT NOT NULL DEFAULT '',
  is_inter_state BOOLEAN NOT NULL DEFAULT false,
  is_cancelled BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT unique_user_invoice_number UNIQUE(user_id, invoice_number)
);

-- 5. INVOICE ITEMS TABLE
CREATE TABLE IF NOT EXISTS public.invoice_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id TEXT NOT NULL REFERENCES public.invoices(id) ON DELETE CASCADE,
  product_id TEXT NOT NULL,
  product_name TEXT NOT NULL,
  barcode TEXT NOT NULL DEFAULT '',
  quantity INTEGER NOT NULL DEFAULT 1,
  price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  gst_rate NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
  gst_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  total NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_profiles_firebase_uid ON public.profiles(firebase_uid);
CREATE INDEX IF NOT EXISTS idx_products_user_id ON public.products(user_id);
CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products(barcode);
CREATE INDEX IF NOT EXISTS idx_customers_user_id ON public.customers(user_id);
CREATE INDEX IF NOT EXISTS idx_invoices_user_id ON public.invoices(user_id);
CREATE INDEX IF NOT EXISTS idx_invoice_items_invoice_id ON public.invoice_items(invoice_id);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Uses Firebase Third-Party Auth: (auth.jwt() ->> 'sub') represents Firebase UID
-- ==============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoice_items ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (firebase_uid = COALESCE(auth.jwt() ->> 'sub', firebase_uid));

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (firebase_uid = COALESCE(auth.jwt() ->> 'sub', firebase_uid));

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (firebase_uid = COALESCE(auth.jwt() ->> 'sub', firebase_uid));

-- Products Policies
DROP POLICY IF EXISTS "Users can view own products" ON public.products;
CREATE POLICY "Users can view own products" ON public.products
  FOR SELECT USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can insert own products" ON public.products;
CREATE POLICY "Users can insert own products" ON public.products
  FOR INSERT WITH CHECK (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can update own products" ON public.products;
CREATE POLICY "Users can update own products" ON public.products
  FOR UPDATE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can delete own products" ON public.products;
CREATE POLICY "Users can delete own products" ON public.products
  FOR DELETE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

-- Customers Policies
DROP POLICY IF EXISTS "Users can view own customers" ON public.customers;
CREATE POLICY "Users can view own customers" ON public.customers
  FOR SELECT USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can insert own customers" ON public.customers;
CREATE POLICY "Users can insert own customers" ON public.customers
  FOR INSERT WITH CHECK (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can update own customers" ON public.customers;
CREATE POLICY "Users can update own customers" ON public.customers
  FOR UPDATE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can delete own customers" ON public.customers;
CREATE POLICY "Users can delete own customers" ON public.customers
  FOR DELETE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

-- Invoices Policies
DROP POLICY IF EXISTS "Users can view own invoices" ON public.invoices;
CREATE POLICY "Users can view own invoices" ON public.invoices
  FOR SELECT USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can insert own invoices" ON public.invoices;
CREATE POLICY "Users can insert own invoices" ON public.invoices
  FOR INSERT WITH CHECK (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can update own invoices" ON public.invoices;
CREATE POLICY "Users can update own invoices" ON public.invoices
  FOR UPDATE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

DROP POLICY IF EXISTS "Users can delete own invoices" ON public.invoices;
CREATE POLICY "Users can delete own invoices" ON public.invoices
  FOR DELETE USING (user_id = COALESCE(auth.jwt() ->> 'sub', user_id));

-- Invoice Items Policies (Cascaded through Parent Invoice's user_id)
DROP POLICY IF EXISTS "Users can view own invoice items" ON public.invoice_items;
CREATE POLICY "Users can view own invoice items" ON public.invoice_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.invoices i
      WHERE i.id = invoice_items.invoice_id
      AND i.user_id = COALESCE(auth.jwt() ->> 'sub', i.user_id)
    )
  );

DROP POLICY IF EXISTS "Users can insert own invoice items" ON public.invoice_items;
CREATE POLICY "Users can insert own invoice items" ON public.invoice_items
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.invoices i
      WHERE i.id = invoice_items.invoice_id
      AND i.user_id = COALESCE(auth.jwt() ->> 'sub', i.user_id)
    )
  );
