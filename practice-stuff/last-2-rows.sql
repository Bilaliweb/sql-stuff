-- We want to get only last two rows from a table regardless of how many rows are there
-- And no condition is needed to apply

-- Basic version
-- Sort the table in DESC order and put a limit of 2
SELECT * FROM students ORDER BY student_id DESC LIMIT 2;


-- Advance Version
-- Use Sub-query and sort the result in actual order
WITH LastTwoRows AS (
    SELECT * FROM students ORDER BY student_id DESC LIMIT 2
)
SELECT * FROM LastTwoRows ORDER BY student_id ASC
