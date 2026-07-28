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