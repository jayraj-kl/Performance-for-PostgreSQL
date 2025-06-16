-- Performance Testing Queries for Partitioning Analysis
-- Compare performance between partitioned and non-partitioned tables

-- ========================================
-- TEST 1: DATE RANGE QUERY COMPARISON
-- ========================================

-- Test 1a: Non-partitioned table (baseline)
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM large_events
WHERE event_time BETWEEN '2023-02-01' AND '2023-02-28';

-- Test 1b: Partitioned table (optimized)
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM partitioned_events
WHERE event_time BETWEEN '2023-02-01' AND '2023-02-28';

-- ========================================
-- TEST 2: CROSS-PARTITION QUERY
-- ========================================

-- Test 2: Query that spans multiple partitions
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM partitioned_events
WHERE event_type = 'purchase';

-- ========================================
-- TEST 3: PARTITION PRUNING DEMONSTRATION
-- ========================================

-- Test 3a: Query hitting single partition
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM partitioned_events
WHERE event_time >= '2023-02-01' AND event_time < '2023-03-01';

-- Test 3b: Query hitting multiple partitions
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM partitioned_events
WHERE event_time >= '2023-02-01' AND event_time < '2023-05-01';

-- ========================================
-- TEST 4: LIST PARTITION PERFORMANCE
-- ========================================

-- Test 4a: Query targeting specific action type
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM user_actions
WHERE action_type = 'login'
AND action_date >= current_date - interval '30 days';

-- Test 4b: Query targeting multiple action types
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM user_actions
WHERE action_type IN ('login', 'logout')
AND action_date >= current_date - interval '30 days';

-- ========================================
-- TEST 5: HASH PARTITION PERFORMANCE
-- ========================================

-- Test 5a: Query targeting specific user (single partition)
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM user_data
WHERE user_id = 123;

-- Test 5b: Query requiring all partitions
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT COUNT(*) FROM user_data
WHERE username LIKE 'user_1%';

-- ========================================
-- PARTITION INFORMATION QUERIES
-- ========================================

-- Query 1: Show partition constraints
SELECT 
    schemaname,
    tablename,
    pg_get_expr(c.conbin, c.conrelid) as partition_constraint
FROM pg_constraint c
JOIN pg_class t ON c.conrelid = t.oid
JOIN pg_namespace n ON t.relnamespace = n.oid
WHERE c.contype = 'c'
AND n.nspname = 'public'
AND t.relname LIKE '%partition%'
ORDER BY t.relname;

-- Query 2: Partition sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size,
    pg_total_relation_size(schemaname||'.'||tablename) as size_bytes
FROM pg_tables 
WHERE schemaname = 'public'
AND (tablename LIKE '%partition%' OR tablename LIKE '%events%' OR tablename LIKE '%actions%' OR tablename LIKE '%data%')
ORDER BY size_bytes DESC;

-- Query 3: Partition statistics
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    seq_scan,
    idx_scan
FROM pg_stat_user_tables
WHERE schemaname = 'public'
AND (tablename LIKE '%partition%' OR tablename LIKE '%events%' OR tablename LIKE '%actions%' OR tablename LIKE '%data%')
ORDER BY tablename;

-- ========================================
-- PERFORMANCE COMPARISON SUMMARY
-- ========================================

-- Query to analyze table access patterns
SELECT 
    'Query Performance Summary' as analysis_type,
    'Check EXPLAIN ANALYZE results above' as details
UNION ALL
SELECT 
    'Partition Pruning Check' as analysis_type,
    'Look for "Partitions removed" in EXPLAIN output' as details
UNION ALL
SELECT 
    'Buffer Usage Analysis' as analysis_type,
    'Compare shared_hit and shared_read between tests' as details;
