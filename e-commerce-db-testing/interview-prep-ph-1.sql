-- 1. SELECT * FROM
-- Fetch all details of employees/users who belong to the 'Sales' department.
SELECT *
FROM employees AS e
    INNER JOIN departments AS d ON d.dept_id = e.department::NUMERIC
WHERE d.dept_name = 'Sales';

-- 2. SELECT DISTINCT
-- List all unique product from orders table.
SELECT DISTINCT product_code
from orderdetails;

-- 3. COUNT
-- Count the number of employees in each department.
SELECT d.dept_name,
    COUNT(*) AS employee_count
FROM employees AS e
    INNER JOIN departments AS d ON d.dept_id = e.department::NUMERIC
GROUP BY d.dept_name;

-- 4. Alias (AS)
-- Display employee names and their salary incremented by 10% as "New Salary".
SELECT e.emp_name AS employee,
    e.salary * 10 / 100 AS increment,
    e.salary + (e.salary * 10 / 100) AS new_salary
FROM employees AS e;

-- 5. WHERE
-- Get details of students who scored above 80 and are in grade 'A'.
-- Relevant to our practice folder

-- 6. LIMIT and ORDER BY
-- Retrieve the names of the top 3 highest scoring students.
-- Relevant to our practice folder

-- 7. Operators and Filtering
-- Get the employees who are either in 'HR' or 'IT' department and earn more than 70,000.
SELECT *
FROM employees AS e
    INNER JOIN departments AS d ON d.dept_id = e.department::NUMERIC
WHERE d.dept_name IN ('HR', 'IT')
    AND e.salary > 70000;

-- 8. BETWEEN, IN, LIKE, and ILIKE
-- Fetch products with prices between 100 and 500.
SELECT *
FROM products AS p
WHERE p.sale_price BETWEEN 100 AND 500;

-- 9. CASE, IF, ELSE
-- Show the product name and its availability status as 'In Stock' if quantity > 0, else 'Out of Stock'.
SELECT p.product_name,
    (CASE
        WHEN p.quantity >= 75 THEN 'In Stock'
        ELSE 'Out of Stock'
    END) AS stock_status
FROM products AS p;

-- 10. COALESCE and NULLIF
    -- Display customer names and delivery dates, but if the delivery date is NULL, show 'Not
    -- Delivered'.
    SELECT 
    c.customer_name AS customer, 
    COALESCE(o.shipped_date::TEXT, 'Not Delivered') AS delivery_data 
    FROM customers AS c
    INNER JOIN orders AS o ON o.customer_number = c.customer_number;
    
-- Advanced Challenges:
    -- 1. Combining Concepts:
    -- - Retrieve all products whose names contain 'a' (case insensitive) and are priced between 50 and
    -- 200, ordered by price in ascending order.
    SELECT * FROM products AS p
    WHERE p.product_name LIKE '%a%' AND p.sale_price BETWEEN 50 AND 200;
    
    -- 2. Using COALESCE and NULLIF Together:
    -- Display employee names and their bonus (salary * 0.1). If the salary is NULL, show the bonus as
    -- 0. If the bonus is 0, show it as NULL.
    -- if salary === null then bonus === 0
    -- if bonus === 0 then bonus === null
    SELECT e.emp_name, e.salary, NULLIF(COALESCE((e.salary * 0.1), 0), 0) AS bonus FROM employees AS e