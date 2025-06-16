-- Performance Monitoring Queries
-- Ongoing performance tracking and optimization metrics

-- 1. Overall database performance metrics
SELECT 
    datname,
    blks_read,
    blks_hit,
    tup_returned,
    tup_fetched,
    tup_inserted,
    tup_updated,
    tup_deleted,
    ROUND((blks_hit * 100.0) / (blks_hit + blks_read), 2) AS cache_hit_ratio
FROM pg_stat_database 
WHERE datname = current_database();

-- 2. Index usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    CASE 
        WHEN idx_scan = 0 THEN 'UNUSED'
        ELSE 'ACTIVE'
    END as usage_status
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- 3. Table scan statistics
SELECT 
    schemaname,
    tablename,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    CASE 
        WHEN seq_scan > idx_scan THEN 'SEQUENTIAL_HEAVY'
        WHEN idx_scan > seq_scan THEN 'INDEX_OPTIMIZED'
        ELSE 'BALANCED'
    END as scan_pattern
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- 4. Lock monitoring
SELECT 
    pg_class.relname,
    pg_locks.locktype,
    pg_locks.mode,
    pg_locks.granted,
    pg_stat_activity.query,
    pg_stat_activity.query_start
FROM pg_locks
JOIN pg_class ON pg_locks.relation = pg_class.oid
JOIN pg_stat_activity ON pg_locks.pid = pg_stat_activity.pid
WHERE NOT pg_locks.granted
ORDER BY pg_stat_activity.query_start;

-- 5. Active connections and query status
SELECT 
    pid,
    usename,
    application_name,
    client_addr,
    state,
    query_start,
    state_change,
    EXTRACT(EPOCH FROM (now() - query_start)) as query_duration_seconds,
    query
FROM pg_stat_activity 
WHERE state != 'idle'
ORDER BY query_start;
