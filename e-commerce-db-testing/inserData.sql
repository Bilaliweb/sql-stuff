-- ==========================================================
-- 1. Optional: COMPLETELY RESET ALL TABLES AND SEQUENCES
-- ==========================================================
-- This single command wipes all data, resets IDs back to 1, 
-- and handles foreign key dependencies automatically.
TRUNCATE TABLE users, categories, products, orders, order_items, payments, shipments 
RESTART IDENTITY CASCADE;

-- ==========================================================
-- 1. INSERT 10 REALISTIC CATEGORIES
-- ==========================================================
INSERT INTO categories (name, description) VALUES
('Electronics', 'Devices, gadgets, and accessories'),
('Clothing', 'Men, women, and children apparel'),
('Books', 'Fiction, non-fiction, and educational'),
('Home & Kitchen', 'Appliances, decor, and utensils'),
('Sports & Outdoors', 'Fitness, camping, and recreational gear'),
('Toys & Games', 'Fun and educational items for all ages'),
('Health & Beauty', 'Skincare, wellness, and personal care'),
('Automotive', 'Car parts, tools, and accessories'),
('Office Supplies', 'Stationery, desk organizers, and tech'),
('Grocery', 'Food, beverages, and household essentials');

-- ==========================================================
-- 2. INSERT 50 REALISTIC PRODUCTS
-- ==========================================================
INSERT INTO products (name, description, price, stock, category_id)
SELECT 
    (ARRAY['Pro Laptop', 'Wireless Earbuds', 'Cotton T-Shirt', 'Running Shoes', 'Bestselling Novel', 
           'Coffee Maker', 'Yoga Mat', 'Board Game', 'Face Serum', 'All-Season Tire', 
           'Mechanical Keyboard', 'Smart Watch', 'Denim Jeans', 'Cookbook', 'Blender', 
           'Camping Tent', 'Puzzle Set', 'Shampoo', 'Motor Oil', 'Desk Lamp'])[1 + (i % 20)] || ' v' || (1 + (i % 5)),
    'High quality item, category ' || (1 + (i % 10)) || '. Rated 4.5+ stars.',
    ROUND((15 + (random() * 485))::numeric, 2), -- Price between $15.00 and $500.00
    (5 + (random() * 195))::int,                -- Stock between 5 and 200
    1 + (i % 10)                                -- Links to category_id 1-10
FROM generate_series(1, 50) AS i;

-- ==========================================================
-- 3. INSERT 150 REALISTIC USERS
-- ==========================================================
INSERT INTO users (name, email, password, phone, address, created_at)
SELECT 
    -- Realistic Name Combination
    (ARRAY['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth', 
           'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Charles', 'Karen'])[1 + (i % 20)] || ' ' || 
    (ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 
           'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin'])[1 + ((i * 3) % 20)],
    
    -- Unique Email (e.g., james.smith1@example.com)
    LOWER(
        (ARRAY['james', 'mary', 'john', 'patricia', 'robert', 'jennifer', 'michael', 'linda', 'william', 'elizabeth', 
               'david', 'barbara', 'richard', 'susan', 'joseph', 'jessica', 'thomas', 'sarah', 'charles', 'karen'])[1 + (i % 20)] || '.' || 
        (ARRAY['smith', 'johnson', 'williams', 'brown', 'jones', 'garcia', 'miller', 'davis', 'rodriguez', 'martinez', 
               'hernandez', 'lopez', 'gonzalez', 'wilson', 'anderson', 'thomas', 'taylor', 'moore', 'jackson', 'martin'])[1 + ((i * 3) % 20)] || i || '@example.com'
    ),
    
    -- Dummy hashed password placeholder
    '$2b$10$dummyHashedPasswordStringForTestingPurposesOnly' || i,
    
    -- Realistic Phone Number
    '555-' || LPAD((1000 + (i % 9000))::text, 4, '0') || '-' || LPAD((1000 + ((i * 7) % 9000))::text, 4, '0'),
    
    -- Realistic Address
    (i % 99 + 1) || ' ' || (ARRAY['Main', 'Elm', 'Oak', 'Pine', 'Cedar', 'Maple', 'Birch', 'Spruce', 'Willow', 'Ash'])[1 + (i % 10)] || ' St, ' || 
    (ARRAY['NY', 'CA', 'TX', 'FL', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI'])[1 + (i % 10)] || ' ' || (10000 + (i % 89999)),
    
    -- Random registration date within the last year
    CURRENT_TIMESTAMP - (random() * interval '365 days')
FROM generate_series(1, 150) AS i;

-- ==========================================================
-- 4. INSERT ~300 ORDERS (Avg 2 orders per user)
-- ==========================================================
INSERT INTO orders (user_id, total_price, status, created_at)
SELECT 
    1 + (i % 150) AS user_id, -- Maps to existing user_ids 1-150
    0.00, -- Placeholder: Will be calculated accurately in Step 5
    (ARRAY['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'])[1 + (i % 5)]::order_status,
    CURRENT_TIMESTAMP - (random() * interval '180 days') -- Random date within last 6 months
FROM generate_series(1, 300) AS i;

-- ==========================================================
-- 5. INSERT ~600 ORDER ITEMS (1 to 3 items per order)
-- ==========================================================
WITH item_data AS (
    SELECT 
        1 + (i % 300) AS order_id,      -- Maps to existing order_ids 1-300
        1 + (i % 50) AS product_id,     -- Maps to existing product_ids 1-50
        1 + (i % 3) AS quantity         -- Quantity between 1 and 3
    FROM generate_series(1, 600) AS i
)
INSERT INTO order_items (order_id, product_id, quantity, price)
SELECT 
    d.order_id,
    d.product_id,
    d.quantity,
    p.price -- Pulls the actual current price from the products table
FROM item_data d
JOIN products p ON d.product_id = p.product_id;

-- ==========================================================
-- 6. UPDATE ORDER TOTALS (Mathematically accurate)
-- ==========================================================
UPDATE orders o
SET total_price = (
    SELECT ROUND(SUM(quantity * price)::numeric, 2)
    FROM order_items oi 
    WHERE oi.order_id = o.order_id
);

-- ==========================================================
-- 7. INSERT PAYMENTS (Linked to orders, realistic statuses)
-- ==========================================================
INSERT INTO payments (order_id, payment_method, payment_status, transaction_id, created_at)
SELECT 
    o.order_id,
    (ARRAY['Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery'])[1 + (o.order_id % 4)]::payment_method_type,
    CASE 
        WHEN o.status = 'Cancelled' THEN 'Failed'::payment_status_type
        WHEN o.status = 'Pending' THEN 'Pending'::payment_status_type
        ELSE 'Completed'::payment_status_type
    END,
    CASE 
        WHEN o.status = 'Cancelled' THEN NULL 
        ELSE 'TXN' || LPAD(o.order_id::text, 6, '0') 
    END,
    o.created_at
FROM orders o;

-- ==========================================================
-- 8. INSERT SHIPMENTS (Only for active/shipping orders)
-- ==========================================================
INSERT INTO shipments (order_id, tracking_number, shipping_status, estimated_delivery, created_at)
SELECT 
    o.order_id,
    CASE WHEN o.status IN ('Shipped', 'Delivered', 'Processing') THEN 'TRACK' || LPAD(o.order_id::text, 6, '0') ELSE NULL END,
    CASE 
        WHEN o.status = 'Delivered' THEN 'Delivered'::shipping_status_type
        WHEN o.status = 'Shipped' THEN 'In Transit'::shipping_status_type
        WHEN o.status = 'Processing' THEN 'Pending'::shipping_status_type
        ELSE NULL 
    END,
    CASE WHEN o.status IN ('Shipped', 'Delivered', 'Processing') THEN o.created_at::date + (random() * 10 + 2)::int ELSE NULL END,
    o.created_at
FROM orders o
WHERE o.status IN ('Processing', 'Shipped', 'Delivered');