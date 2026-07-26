-- ==========================================
-- 1. CREATE CUSTOM ENUM TYPES FIRST
-- ==========================================
CREATE TYPE order_status AS ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled');
CREATE TYPE payment_method_type AS ENUM ('Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery');
CREATE TYPE payment_status_type AS ENUM ('Pending', 'Completed', 'Failed', 'Refunded');
CREATE TYPE shipping_status_type AS ENUM ('Pending', 'Dispatched', 'In Transit', 'Delivered');

-- ==========================================
-- 2. CREATE TABLES
-- ==========================================

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table (Fixed: removed INT before SERIAL)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- Orders Table (Fixed: uses the custom order_status ENUM type)
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT,
    total_price DECIMAL(10,2) NOT NULL,
    status order_status DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Payments Table (Fixed: uses the custom payment ENUM types)
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE,
    payment_method payment_method_type NOT NULL,
    payment_status payment_status_type DEFAULT 'Pending',
    transaction_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Shipments Table (Fixed: uses the custom shipping_status ENUM type)
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE,
    tracking_number VARCHAR(50) UNIQUE,
    shipping_status shipping_status_type DEFAULT 'Pending',
    estimated_delivery DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);