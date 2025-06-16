-- Indexing Strategies - Index Creation Commands
-- Creating various indexes to test performance impact

-- Connect to BaseCase database
\c BaseCase

-- Create a basic B-tree index on account ID
-- This creates a duplicate of the primary key index for testing
CREATE INDEX idx_accounts_aid ON pgbench_accounts (aid);

-- Verify index creation
\di+ idx_accounts_aid

-- Example: Create index on balance column (commented out - would need data modification)
-- CREATE INDEX idx_accounts_balance ON pgbench_accounts (abalance);

-- Example: Create composite index (commented out for this test)
-- CREATE INDEX idx_accounts_aid_balance ON pgbench_accounts (aid, abalance);

-- Example: Create partial index (commented out for this test)  
-- CREATE INDEX idx_accounts_positive_balance ON pgbench_accounts (aid) WHERE abalance > 0;

-- Check all indexes on pgbench_accounts table
SELECT 
    indexname,
    indexdef,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes 
WHERE tablename = 'pgbench_accounts'
ORDER BY indexname;
