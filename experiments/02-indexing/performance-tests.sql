-- Performance Testing Queries for Index Analysis
-- These queries test different access patterns and index usage

-- Test 1: Point lookup using primary key
EXPLAIN ANALYZE 
SELECT * FROM pgbench_accounts WHERE aid = 123456;

-- Test 2: Point lookup using custom index  
EXPLAIN ANALYZE 
SELECT * FROM pgbench_accounts WHERE aid = 123456;

-- Test 3: Range scan without appropriate index (slow!)
EXPLAIN (ANALYZE, BUFFERS, TIMING) 
SELECT * FROM pgbench_accounts WHERE abalance = 0;

-- Test 4: Detailed performance analysis with buffers
EXPLAIN (ANALYZE, BUFFERS, TIMING) 
SELECT * FROM pgbench_accounts WHERE aid = 12345;

-- Test 5: Index usage statistics
SELECT 
    relname, 
    indexrelname, 
    idx_scan, 
    idx_tup_read, 
    idx_tup_fetch 
FROM pg_stat_user_indexes 
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;

-- Test 6: Table access patterns
SELECT 
    schemaname,
    tablename,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    n_tup_ins,
    n_tup_upd,
    n_tup_del
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY seq_scan DESC;

-- Test 7: Index efficiency analysis
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    CASE 
        WHEN idx_scan > 0 
        THEN round(idx_tup_fetch::numeric / idx_scan, 2) 
        ELSE 0 
    END as avg_tuples_per_scan
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;
