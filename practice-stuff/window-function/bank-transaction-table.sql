-- Create a table for bank transactions
CREATE TABLE IF NOT EXISTS bank_transactions (
    transaction_id INT PRIMARY KEY,
    account_holder VARCHAR(100),
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount DECIMAL(10, 2)
)