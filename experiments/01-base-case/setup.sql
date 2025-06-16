-- Base Case Database Setup
-- Initialize pgbench schema with scaling factor 100

-- Connect to the BaseCase database
\c BaseCase

-- Initialize pgbench tables and data
-- This is equivalent to: pgbench -i -s 100 mydatabase
-- Command: pgbench -i -s 100 -h database-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com -p 5432 -U postgres -d BaseCase

-- Note: This file documents the setup process
-- The actual initialization is done via pgbench command line tool

-- Verify tables are created
\dt

-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size,
    pg_total_relation_size(schemaname||'.'||tablename) as size_bytes
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
