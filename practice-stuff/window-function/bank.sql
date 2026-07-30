-- We have to acheive Rolling Total or Cumulative Sum for our bank transaction table
-- Rolling total means:
-- Let's say we have a table with a specific column as amount
-- Now if there are 5 rows for same user, the column will look like:
-- Row 1: amount - 10,000 added first time
-- Row 2: amount - 25,000 after addition of 15k in previous 10k
-- Row 3 to Row 5 will be the same process

-- Understanding Window function.
-- When we talk about it, we don't talk about table, we talk about window.
-- Basically, When sql iterate over the rows, those rows become window.

-- For example:
-- We have to apply window function on bank table and show the sum of users's amount as total amount.
-- That sum would be known as 'Cumulative Sum'
-- Now if a specific user has 4 rows, then window will be all 4 rows.
-- SQL will check all 4 rows everytime it iterate over row turn by turn.
-- i.e: Row 1: Checks all 4 rows and sum up the amount for 4 rows and display in our new column
-- Same goes for Row 2 to Row 4
-- This will show the same result of sum for all respective row regardless of whatever the amount row is showing

SELECT *, SUM(amount) 
OVER(PARTITION BY account_holder) AS total_sum
FROM bank_transactions;


-- Now let's say:
-- We want to show actual current or closing balance instead of same result on all rows.
-- i.e; if Row 1 has closing balance as 25k upon deposit
-- Then in Row 2 user withdrew 10k from his current balance then remaining will be 15k
-- Then in Row 3 user deposited again 35k then total is -> 25-10+35 = 50k
-- As per standards, Row 2 should show 15k in closing_balance instead of total as 50k which doesn't even make sense
-- So Row 2 should show 15k
-- This works by using ORDER BY for specific column which will restrict sql to have a single row as complete window
-- i.e; 
-- When iterating over rows:
-- Row 1 will be complete window for sql
-- When comes to Row 2 then sql will have Row 2 and Row 1 as complete window
-- In simple words -> window = nth row + nth row - 1 => window = 6 + 6-1 = 6 + 5 => means 
-- When on 6th row, sql will have a window for previous 5 rows as well along with 6th row

SELECT *, SUM(amount) 
OVER(
    PARTITION BY account_holder
    ORDER BY transaction_date
) AS closing_balance
FROM bank_transactions;