-- Run this SQL in Supabase SQL Editor to provision tables.
-- It mirrors your Prisma models with minimal changes.

create table if not exists "States" (
  id serial primary key,
  state_name varchar(50) not null,
  state_code varchar(2) not null,
  state_numeric_code int unique not null
);

create table if not exists "BusinessProfile" (
  id serial primary key,
  business_name varchar(255) not null,
  gstin varchar(15) unique not null,
  address text not null,
  city varchar(100) not null,
  vat_tin varchar(20),
  state_id int,
  pan_number varchar(10),
  bank_name varchar(100),
  account_number varchar(20),
  branch_ifsc varchar(20),
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  "deletedAt" timestamptz,
  constraint fk_business_state foreign key (state_id) references "States"(id)
);

create table if not exists "Customer" (
  id serial primary key,
  name varchar(255) not null,
  address text not null,
  city varchar(100) not null,
  pincode varchar(10),
  gstin varchar(15) unique,
  phone varchar(15) not null,
  email varchar(100),
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  state_id int,
  pan_number varchar(10),
  "deletedAt" timestamptz,
  constraint fk_customer_state foreign key (state_id) references "States"(id)
);

create table if not exists "Invoice" (
  id serial primary key,
  invoice_number varchar(50) unique not null,
  invoice_date timestamptz not null,
  transaction_type varchar(20) not null,
  input_mode varchar(20) not null,
  eway_bill varchar(50),
  buyer_id int,
  buyer_name varchar(255) not null,
  buyer_address text not null,
  buyer_gstin varchar(15),
  buyer_state_code int,
  tax_type varchar(20) not null,
  total_invoice_value numeric(12,3) not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  flagged boolean default false not null,
  "deletedAt" timestamptz,
  roundoff numeric(12,3),
  constraint fk_invoice_customer foreign key (buyer_id) references "Customer"(id)
);

create table if not exists "LineItem" (
  id serial primary key,
  invoice_id int not null,
  hsn_sac_code varchar(10) not null,
  description varchar(255) not null,
  quantity numeric(10,3) not null,
  unit varchar(10) not null,
  rate numeric(12,3) not null,
  taxable_value numeric(12,3) not null,
  created_at timestamptz default now() not null,
  roundoff numeric(12,3) default 0.00 not null,
  "deletedAt" timestamptz,
  constraint fk_lineitem_invoice foreign key (invoice_id) references "Invoice"(id)
);

create table if not exists "LineItemTax" (
  id serial primary key,
  line_item_id int not null,
  tax_name varchar(20) not null,
  tax_rate numeric(5,3) not null,
  tax_amount numeric(12,3) not null,
  created_at timestamptz default now() not null,
  "deletedAt" timestamptz,
  constraint fk_tax_lineitem foreign key (line_item_id) references "LineItem"(id)
);

create table if not exists "InvoiceSetting" (
  id serial primary key,
  invoice_prefix varchar(20) not null default 'JVJ/D/',
  default_transaction_type varchar(20) not null default 'retail',
  number_digits int not null default 3,
  default_input_mode varchar(20) not null default 'component',
  starting_number int not null default 1,
  generate_original boolean not null default true,
  generate_duplicate boolean not null default true,
  generate_triplicate boolean not null default true,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  prefix_inter_city varchar(20) not null default 'JVJ/D/',
  prefix_outer_state varchar(20) not null default 'JVJ/S/',
  prefix_retail varchar(20) not null default 'JVJ/D/'
);

create table if not exists "TaxRate" (
  id serial primary key,
  hsn_code varchar(100) not null,
  description varchar(255) not null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  "deletedAt" timestamptz,
  is_default boolean not null default false
);

create table if not exists "User" (
  id serial primary key,
  email varchar(100) unique not null,
  password varchar(255) not null,
  name varchar(100) not null,
  role varchar(20) not null default 'admin',
  is_active boolean not null default true,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  "deletedAt" timestamptz
);

-- Helpful indexes
create index if not exists idx_customer_deleted on "Customer"("deletedAt");
create index if not exists idx_invoice_deleted on "Invoice"("deletedAt");
create index if not exists idx_lineitem_invoice on "LineItem"(invoice_id);

-- Row Level Security (example enable; define policies as needed)
alter table "Customer" enable row level security;
alter table "Invoice" enable row level security;
alter table "LineItem" enable row level security;
alter table "LineItemTax" enable row level security;


