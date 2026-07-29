-- Use Views
-- Show the product name and its availability status as 'In Stock' if quantity > 0, else 'Out of Stock'.
CREATE VIEW stock_view AS
SELECT p.product_name,
    (
        CASE
            WHEN p.quantity >= 75 THEN 'In Stock'
            ELSE 'Out of Stock'
        END
    ) AS stock_status
FROM products AS p;


-- Now get the data from created view
SELECT * FROM stock_view;


-- Grant permissions to above user as per needs
-- We are giving only SELECT permission for specific 'View'
GRANT SELECT ON public.stock_view TO user_test;

-- For Updating the view we can simply use CREATE OR REPLACE 
-- Let's say if you want to alter the logic, add a column, or change a filter inside the view
-- Make sure while replacing/updating the view, new columns should be added at the end to avoid errors
-- Cuz PSQL will not allow to alter the columns sequence
CREATE OR REPLACE VIEW public.stock_view AS 
SELECT p.product_name,
    (
        CASE
            WHEN p.quantity >= 75 THEN 'In Stock'
            ELSE 'Out of Stock'
        END
    ) AS stock_status,
    p.quantity,
    p.product_code,
    p.category,
    p.product_description,
    p.buy_price,
    p.sale_price
FROM products AS p;


-- We can also drop a view if needed using DROP command
-- DROP VIEW public.stock_view CASCADE;


-- We can also perform insert and update actions as well on views 
-- But columns should match to original table, we made a logic from. i.e; products
-- If columns don't match, query will throw errors as per schema
-- For this reason, we updated the above query for view in CREATE OR REPLACE (line no. 26-40)
INSERT INTO stock_view(product_code, product_name, category, product_description, quantity, buy_price, sale_price) VALUES
('$test_code', 'Test Product', 'Motorcycles', 'Test description', 120, 65, 130);