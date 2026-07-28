-- ==========================================================
-- 1. HARD RESET (Guarantees clean state)
-- ==========================================================
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS orderdetails CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS offices CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS demo_table CASCADE;

BEGIN;

-- ==========================================================
-- 2. CREATE TABLES
-- ==========================================================
CREATE TABLE departments (dept_id SERIAL PRIMARY KEY, dept_name VARCHAR(50));

CREATE TABLE offices (
    office_code VARCHAR(10) PRIMARY KEY,
    city VARCHAR(50) NOT NULL, phone VARCHAR(50) NOT NULL,
    address_line1 VARCHAR(50) NOT NULL, address_line2 VARCHAR(50),
    state VARCHAR(50), country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(15) NOT NULL, territory VARCHAR(10) NOT NULL
);

CREATE TABLE categories (category VARCHAR(50) PRIMARY KEY);

CREATE TABLE demo_table (
    name VARCHAR(30), college VARCHAR(30),
    exam_date VARCHAR(30), subjects VARCHAR(30), marks INT
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL, salary BIGINT,
    email VARCHAR(100) NOT NULL UNIQUE,
    office_code VARCHAR(10) NOT NULL,
    reports_to INT, job_title VARCHAR(50) NOT NULL,
    department VARCHAR(100), level VARCHAR(100),
    FOREIGN KEY (office_code) REFERENCES offices(office_code) ON DELETE RESTRICT
);

CREATE TABLE customers (
    customer_number SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    contact_last_name VARCHAR(50) NOT NULL,
    contact_first_name VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    address_line1 VARCHAR(50) NOT NULL, address_line2 VARCHAR(50),
    city VARCHAR(50) NOT NULL, state VARCHAR(50),
    postal_code VARCHAR(15), country VARCHAR(50) NOT NULL,
    sales_rep_employee_number INT, credit_limit DECIMAL(10,2),
    FOREIGN KEY (sales_rep_employee_number) REFERENCES employees(employee_id) ON DELETE SET NULL
);

CREATE TABLE products (
    product_code VARCHAR(15) PRIMARY KEY,
    product_name VARCHAR(70) NOT NULL, category VARCHAR(50) NOT NULL,
    product_description TEXT NOT NULL, quantity SMALLINT NOT NULL,
    buy_price DECIMAL(10,2) NOT NULL, sale_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category) REFERENCES categories(category) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_number INT PRIMARY KEY, -- Changed to INT for explicit seeding
    order_date DATE NOT NULL, required_date DATE NOT NULL,
    shipped_date DATE, status VARCHAR(15) NOT NULL,
    comments TEXT, customer_number INT NOT NULL,
    FOREIGN KEY (customer_number) REFERENCES customers(customer_number) ON DELETE RESTRICT
);

CREATE TABLE orderdetails (
    order_number INT NOT NULL,
    product_code VARCHAR(15) NOT NULL,
    quantity_ordered INT NOT NULL,
    price_each DECIMAL(10,2) NOT NULL,
    order_line_number SMALLINT NOT NULL,
    PRIMARY KEY (order_number, product_code),
    FOREIGN KEY (order_number) REFERENCES orders(order_number) ON DELETE CASCADE,
    FOREIGN KEY (product_code) REFERENCES products(product_code) ON DELETE CASCADE
);

CREATE TABLE payments (
    customer_number INT NOT NULL, check_number VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL, amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (customer_number, check_number),
    FOREIGN KEY (customer_number) REFERENCES customers(customer_number) ON DELETE CASCADE
);

-- ==========================================================
-- 3. INSERT BASE DATA
-- ==========================================================
INSERT INTO departments (dept_name) VALUES ('HR'), ('Finance'), ('IT'), ('Sales'), ('Marketing');

INSERT INTO offices (office_code, city, phone, address_line1, country, postal_code, territory) VALUES
('SF', 'San Francisco', '+1-650-555-0100', '100 Market St', 'USA', '94105', 'NA'),
('NY', 'New York', '+1-212-555-0101', '200 Park Ave', 'USA', '10017', 'NA'),
('LDN', 'London', '+44-20-555-0102', '10 Downing St', 'UK', 'SW1A 2AA', 'EMEA'),
('TKY', 'Tokyo', '+81-3-555-0103', '1-1 Chiyoda', 'Japan', '100-0001', 'APAC');

INSERT INTO categories (category) VALUES ('Classic Cars'), ('Motorcycles'), ('Vintage Cars'), ('Planes'), ('Ships'), ('Trucks and Buses');

INSERT INTO employees (emp_name, salary, email, office_code, reports_to, job_title, department, level) VALUES
('Diane Murphy', 150000, 'diane@classicmodels.com', 'SF', NULL, 'President', '1', 'EXEC'),
('Mary Patterson', 120000, 'mary@classicmodels.com', 'SF', 1, 'VP Sales', '4', 'EXEC'),
('John Smith', 95000, 'john@classicmodels.com', 'SF', 2, 'Sales Manager', '4', 'SENIOR'),
('Jane Doe', 85000, 'jane@classicmodels.com', 'NY', 2, 'Sales Rep', '4', 'MID'),
('Bob Wilson', 75000, 'bob@classicmodels.com', 'NY', 3, 'Sales Rep', '4', 'MID'),
('Alice Brown', 90000, 'alice@classicmodels.com', 'LDN', 2, 'Sales Manager', '4', 'SENIOR'),
('Charlie Davis', 70000, 'charlie@classicmodels.com', 'LDN', 6, 'Sales Rep', '4', 'JUNIOR'),
('Eva Martinez', 80000, 'eva@classicmodels.com', 'TKY', 2, 'Sales Rep', '4', 'MID'),
('Frank Lee', 65000, 'frank@classicmodels.com', 'SF', 1, 'IT Manager', '3', 'SENIOR'),
('Grace Kim', 60000, 'grace@classicmodels.com', 'SF', 9, 'Developer', '3', 'MID'),
('Henry Chen', 55000, 'henry@classicmodels.com', 'NY', 9, 'Developer', '3', 'JUNIOR'),
('Ivy Wang', 70000, 'ivy@classicmodels.com', 'LDN', 1, 'HR Manager', '1', 'SENIOR');

INSERT INTO customers (customer_name, contact_last_name, contact_first_name, phone, address_line1, city, country, postal_code, sales_rep_employee_number, credit_limit) VALUES
('Atelier Graphique', 'Schmitt', 'Carine', '40.32.2555', '54 rue Royale', 'Nantes', 'France', '44000', 7, 21000.00),
('Signal Gift Stores', 'King', 'Jean', '702-555-1838', '8489 Strong St', 'Las Vegas', 'USA', '83030', 4, 71800.00),
('Australian Collectors', 'Ferguson', 'Peter', '03-9520-4555', '636 St Kilda Rd', 'Melbourne', 'Australia', '3004', 6, 117300.00),
('La Rochelle Gifts', 'Labrune', 'Janine', '40.67.8555', '67 rue des Otages', 'Nantes', 'France', '44000', 7, 118200.00),
('Baane Mini Imports', 'Bergulfsen', 'Jonas', '07-98-9555', 'Erling Skakkes gate 78', 'Stavern', 'Norway', '4110', 5, 81700.00),
('Mini Gifts Distributors', 'Nelson', 'Susan', '415-555-1450', '5677 Strong St', 'San Rafael', 'USA', '97562', 3, 210500.00),
('Euro+ Shopping', 'Freyre', 'Diego', '91-555-94-44', 'C/ Moralzarzal 86', 'Madrid', 'Spain', '28034', 7, 227600.00),
('Danish Wholesale', 'Petersen', 'Jytte', '31-12-3555', 'Vinbaeltet 34', 'Kobenhavn', 'Denmark', '1734', 8, 83400.00),
('Saveley & Henriot', 'Saveley', 'Mary', '78.32.5555', '2 rue du Commerce', 'Lyon', 'France', '69004', 7, 123900.00),
('Muscle Machine Inc', 'Young', 'Jeff', '212-555-7413', '4092 Furth Circle', 'NYC', 'USA', '10022', 9, 138500.00),
('Diecast Classics', 'Leong', 'Kelvin', '215-555-1555', '7586 Pompton St', 'Allentown', 'USA', '70267', 10, 100600.00),
('Technics Stores', 'Hashimoto', 'Juri', '650-555-6809', '9408 Furth Circle', 'Burlingame', 'USA', '94217', 3, 84600.00),
('Handji Gifts', 'Victorino', 'Wendy', '+65-224-1555', '106 Linden Road', 'Singapore', 'Singapore', '069045', 11, 97900.00),
('Herkku Gifts', 'Oeztan', 'Veysel', '+47-2267-3215', 'Brehmen St. 121', 'Bergen', 'Norway', 'N 5804', 5, 96800.00),
('American Souvenirs', 'Franco', 'Keith', '203-555-7845', '149 Spinnaker Dr', 'New Haven', 'USA', '97823', 9, 50000.00);

INSERT INTO products (product_code, product_name, category, product_description, quantity, buy_price, sale_price) VALUES
('S10_1678', '1969 Harley Davidson Chopper', 'Motorcycles', 'Working kickstand, suspension, gear-shift. Delicate parts.', 100, 48.81, 95.70),
('S10_1949', '1952 Alpine Renault 1300', 'Classic Cars', 'Turnable wheels, detailed interior, opening hood/trunk.', 150, 98.58, 214.30),
('S10_2016', '1996 Moto Guzzi 1100i', 'Motorcycles', 'Official logos, saddle bags, detailed engine.', 80, 68.99, 118.94),
('S12_1099', '1968 Ford Mustang', 'Classic Cars', 'Hood/doors/trunk open, detailed interior, dark green.', 200, 95.34, 194.57),
('S12_1108', '2001 Ferrari Enzo', 'Classic Cars', 'Turnable wheels, detailed engine, opening hood.', 50, 95.59, 207.80),
('S18_1749', '1917 Grand Touring Sedan', 'Vintage Cars', 'Museum quality, opening doors/hood, chrome trim.', 75, 86.70, 170.00),
('S18_2581', 'P-51-D Mustang', 'Planes', 'Retractable wheels, comes with stand.', 120, 49.00, 84.48),
('S18_3029', '1999 Yamaha Speed Boat', 'Ships', 'Wood/metal replica, rigging, three masts.', 90, 51.61, 86.02),
('S24_1046', '1970 Chevy Chevelle SS 454', 'Classic Cars', 'Rotating wheels, working steering, opening doors.', 110, 49.24, 73.49),
('S24_1578', '1997 BMW R 1100 S', 'Motorcycles', 'Working suspension, 70+ parts.', 60, 60.86, 112.70),
('S32_1268', '1980 GM Manhattan Express', 'Trucks and Buses', '35 windows, working lights, needs battery.', 40, 53.93, 96.31),
('S50_1341', '1930 Buick Marquette Phaeton', 'Vintage Cars', 'Opening trunk, working steering.', 85, 27.06, 43.64),
('S700_1138', 'The Schooner Bluenose', 'Ships', 'Wood/canvas, 31.5" long, many extras.', 30, 34.00, 66.67),
('S700_1691', 'American Airlines B767-300', 'Planes', 'Exact replica, retractable wheels, official logos.', 45, 51.15, 91.34),
('S72_3212', 'Pont Yacht', 'Ships', '38" long, includes stand, rigging, 2 masts.', 25, 33.30, 54.60);

-- ==========================================================
-- 4. INSERT ORDERS (Explicit IDs 1-20 for guaranteed FK match)
-- ==========================================================
INSERT INTO orders (order_number, order_date, required_date, shipped_date, status, comments, customer_number) VALUES
(1, '2024-01-15', '2024-01-22', '2024-01-18', 'Shipped', NULL, 1),
(2, '2024-01-20', '2024-01-28', '2024-01-25', 'Shipped', 'Rush order', 2),
(3, '2024-02-01', '2024-02-10', '2024-02-05', 'Shipped', NULL, 3),
(4, '2024-02-10', '2024-02-18', NULL, 'Processing', 'Awaiting payment', 4),
(5, '2024-02-15', '2024-02-25', '2024-02-20', 'Shipped', NULL, 5),
(6, '2024-03-01', '2024-03-10', '2024-03-05', 'Shipped', 'Gift wrap requested', 6),
(7, '2024-03-10', '2024-03-18', NULL, 'Cancelled', 'Customer changed mind', 7),
(8, '2024-03-15', '2024-03-22', '2024-03-19', 'Shipped', NULL, 8),
(9, '2024-04-01', '2024-04-10', '2024-04-05', 'Shipped', NULL, 9),
(10, '2024-04-10', '2024-04-18', NULL, 'Processing', NULL, 10),
(11, '2024-04-15', '2024-04-25', '2024-04-20', 'Shipped', 'Express shipping', 11),
(12, '2024-05-01', '2024-05-10', '2024-05-05', 'Shipped', NULL, 12),
(13, '2024-05-10', '2024-05-18', NULL, 'On Hold', 'Credit limit check', 13),
(14, '2024-05-15', '2024-05-22', '2024-05-19', 'Shipped', NULL, 14),
(15, '2024-06-01', '2024-06-10', '2024-06-05', 'Shipped', NULL, 15),
(16, '2024-06-10', '2024-06-18', NULL, 'Processing', NULL, 1),
(17, '2024-06-15', '2024-06-25', '2024-06-20', 'Shipped', 'Bulk order discount', 2),
(18, '2024-07-01', '2024-07-10', '2024-07-05', 'Shipped', NULL, 3),
(19, '2024-07-10', '2024-07-18', NULL, 'Processing', 'Awaiting stock', 4),
(20, '2024-07-15', '2024-07-22', '2024-07-19', 'Shipped', NULL, 5);

-- ==========================================================
-- 5. INSERT ORDER DETAILS (Strictly references 1-20)
-- ==========================================================
INSERT INTO orderdetails (order_number, product_code, quantity_ordered, price_each, order_line_number) VALUES
(1, 'S10_1678', 2, 95.70, 1), (1, 'S18_2581', 1, 84.48, 2), (1, 'S72_3212', 1, 54.60, 3),
(2, 'S10_1949', 1, 214.30, 1), (2, 'S18_3029', 1, 86.02, 2),
(3, 'S12_1099', 3, 194.57, 1), (3, 'S24_1046', 2, 73.49, 2), (3, 'S700_1691', 1, 91.34, 3),
(4, 'S18_1749', 1, 170.00, 1), (5, 'S10_2016', 2, 118.94, 1), (5, 'S32_1268', 1, 96.31, 2),
(6, 'S12_1108', 1, 207.80, 1), (7, 'S18_3029', 2, 86.02, 1), (8, 'S24_1578', 1, 112.70, 1),
(8, 'S50_1341', 3, 43.64, 2), (9, 'S700_1138', 1, 66.67, 1), (10, 'S700_1691', 2, 91.34, 1),
(11, 'S10_1678', 1, 95.70, 1), (11, 'S18_2581', 2, 84.48, 2), (12, 'S10_1949', 1, 214.30, 1),
(13, 'S12_1099', 2, 194.57, 1), (14, 'S24_1046', 1, 73.49, 1), (14, 'S32_1268', 1, 96.31, 2),
(15, 'S18_1749', 1, 170.00, 1), (16, 'S10_2016', 2, 118.94, 1), (17, 'S12_1108', 1, 207.80, 1),
(18, 'S18_3029', 1, 86.02, 1), (19, 'S24_1578', 2, 112.70, 1), (20, 'S50_1341', 1, 43.64, 1),
(20, 'S700_1138', 1, 66.67, 2);

-- ==========================================================
-- 6. INSERT PAYMENTS & DEMO
-- ==========================================================
INSERT INTO payments (customer_number, check_number, payment_date, amount) VALUES
(1, 'CHK-001', '2024-01-20', 6066.78), (1, 'CHK-002', '2024-03-15', 14571.44),
(2, 'CHK-003', '2024-01-25', 14191.12), (2, 'CHK-004', '2024-04-10', 32641.98),
(3, 'CHK-005', '2024-02-05', 45864.03), (3, 'CHK-006', '2024-05-20', 82261.22),
(4, 'CHK-007', '2024-02-12', 19501.82), (5, 'CHK-008', '2024-02-22', 50218.95),
(6, 'CHK-009', '2024-03-08', 101244.59), (7, 'CHK-010', '2024-03-12', 22292.62),
(8, 'CHK-011', '2024-03-20', 36251.03), (9, 'CHK-012', '2024-04-08', 4710.73),
(10, 'CHK-013', '2024-04-15', 58793.53), (11, 'CHK-014', '2024-05-10', 35152.12),
(12, 'CHK-015', '2024-05-18', 2434.25);

INSERT INTO demo_table (name, college, exam_date, subjects, marks) VALUES
('Romy', 'BVCOE', '12-OCT-2021', 'DBMS', 90), ('Romy', 'BVCOE', '12-OCT-2021', 'NETWORKING', 90),
('Romy', 'BVCOE', '12-OCT-2021', 'GRAPHICS', 100), ('Pushkar', 'MSIT', '14-OCT-2021', 'DBMS', 79),
('Pushkar', 'MSIT', '14-OCT-2021', 'NETWORKING', 97), ('Pushkar', 'MSIT', '14-OCT-2021', 'GRAPHICS', 98),
('Alice', 'IIT', '15-OCT-2021', 'MATH', 85), ('Bob', 'NIT', '16-OCT-2021', 'PHYSICS', 78),
('Charlie', 'BIT', '17-OCT-2021', 'CHEMISTRY', 92), ('Diana', 'VIT', '18-OCT-2021', 'BIOLOGY', 88);

-- ==========================================================
-- 7. DEFERRED FK FOR EMPLOYEES
-- ==========================================================
ALTER TABLE employees 
ADD CONSTRAINT fk_reports_to 
FOREIGN KEY (reports_to) REFERENCES employees(employee_id) ON DELETE SET NULL;

COMMIT;