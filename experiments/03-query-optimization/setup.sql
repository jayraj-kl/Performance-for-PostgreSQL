-- Query Optimization Setup
-- Enable performance monitoring and slow query logging

-- Enable pg_stat_statements extension for query analysis
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Enable slow query logging (queries taking > 1 second)
ALTER SYSTEM SET log_min_duration_statement = 1000;

-- Reload configuration
SELECT pg_reload_conf();

-- Verify pg_stat_statements is working
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows
FROM pg_stat_statements 
WHERE query NOT LIKE '%pg_stat_statements%'
ORDER BY calls DESC 
LIMIT 5;

-- Check current logging configuration
SHOW log_min_duration_statement;

-- Reset pg_stat_statements if needed for clean baseline
-- SELECT pg_stat_statements_reset();
