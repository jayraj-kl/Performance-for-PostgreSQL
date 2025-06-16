-- Slow Query Analysis
-- Identify and analyze performance bottlenecks

-- 1. Find queries taking more than 1 second
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    (total_exec_time / calls) as avg_time_ms,
    rows,
    100.0 * shared_blks_hit / (shared_blks_hit + shared_blks_read) as hit_percent
FROM pg_stat_statements 
WHERE mean_exec_time > 1000
ORDER BY total_exec_time DESC
LIMIT 10;

-- 2. Find most frequently executed queries
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows
FROM pg_stat_statements 
ORDER BY calls DESC 
LIMIT 10;

-- 3. Find queries with highest total execution time
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    (total_exec_time / sum(total_exec_time) OVER()) * 100 as percent_total_time
FROM pg_stat_statements 
ORDER BY total_exec_time DESC 
LIMIT 10;

-- 4. Analyze buffer performance for top queries
SELECT 
    query,
    calls,
    shared_blks_hit,
    shared_blks_read,
    shared_blks_dirtied,
    CASE 
        WHEN (shared_blks_hit + shared_blks_read) > 0 
        THEN (shared_blks_hit * 100.0 / (shared_blks_hit + shared_blks_read))
        ELSE 0 
    END as cache_hit_percent
FROM pg_stat_statements 
WHERE shared_blks_read > 0
ORDER BY shared_blks_read DESC
LIMIT 10;
