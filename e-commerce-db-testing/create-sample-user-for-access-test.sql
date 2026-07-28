-- Create a user who will have limited access to the database as per we permit
-- This will be a postgres user and we can decide which db we have to give him access for
CREATE USER user_test WITH PASSWORD '12345678';

-- We want to restrict user now to only specific tables
-- Step 1: Revoke any default global table access (just to be safe) (Remove permission for every table)
-- This will show all the tables in db but no action can be performed and if tried, will get 'permission denied' error
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM user_test;

-- Step 2: Allow the user to see inside the schema namespace
GRANT USAGE ON SCHEMA public TO user_test;

-- Step 3: Grant access to ONLY your 2 specific tables
-- Due to this user will only be able to do SELECT queries
-- And will be restricted for any other crud operation
GRANT SELECT ON public.employees TO user_test;
GRANT SELECT ON public.departments TO user_test;


-- Grant permissions to above user as per needs
-- We are giving only SELECT permission for specific 'View'


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
    p.quantity
FROM products AS p;


-- We can also drop a view if needed using DROP command
-- DROP VIEW public.stock_view CASCADE;