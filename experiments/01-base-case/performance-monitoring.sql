-- Database Performance Monitoring Queries
-- Used to track statistics during base case testing

-- Query 1: Database statistics overview
SELECT 
    datname, 
    blks_read, 
    blks_hit, 
    tup_returned, 
    tup_fetched, 
    tup_inserted, 
    tup_updated, 
    tup_deleted 
FROM pg_stat_database 
WHERE datname = current_database();

-- Query 2: Cache hit ratio calculation
SELECT 
    datname,
    blks_read,
    blks_hit,
    CASE 
        WHEN (blks_read + blks_hit) > 0 
        THEN round((blks_hit * 100.0) / (blks_hit + blks_read), 2)
        ELSE 0 
    END AS hit_ratio_percent
FROM pg_stat_database 
WHERE datname = current_database();

-- Query 3: Table statistics
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples
FROM pg_stat_user_tables
ORDER BY (n_tup_ins + n_tup_upd + n_tup_del) DESC;

-- Query 4: Index usage statistics  
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
