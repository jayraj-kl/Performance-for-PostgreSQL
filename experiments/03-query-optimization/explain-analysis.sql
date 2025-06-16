-- EXPLAIN ANALYZE Examples
-- Detailed execution plan analysis for query optimization

-- Example 1: Basic SELECT with EXPLAIN ANALYZE
-- Replace with your actual slow query
EXPLAIN (ANALYZE, BUFFERS, TIMING) 
SELECT * FROM pgbench_accounts WHERE aid = 12345;

-- Example 2: JOIN query analysis
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT a.*, b.bid 
FROM pgbench_accounts a 
JOIN pgbench_branches b ON a.bid = b.bid 
WHERE a.abalance > 1000;

-- Example 3: Aggregation query analysis
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT bid, COUNT(*), AVG(abalance), SUM(abalance)
FROM pgbench_accounts 
GROUP BY bid;

-- Example 4: Complex WHERE clause analysis
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT COUNT(*) 
FROM pgbench_accounts 
WHERE abalance BETWEEN 500 AND 1500 
AND bid IN (1, 2, 3);

-- Understanding EXPLAIN output:
-- 
-- Cost format: (startup_cost..total_cost rows=estimated_rows width=avg_row_width)
-- 
-- Key metrics to watch:
-- - Actual time: Real execution time
-- - Rows: Actual vs estimated rows
-- - Buffers hit/read: Memory vs disk access
-- - Planning time: Query preparation overhead
-- - Execution time: Actual query execution time
--
-- Red flags:
-- - Sequential scans on large tables
-- - High buffer reads (disk I/O)
-- - Large row count discrepancies
-- - Long planning times
