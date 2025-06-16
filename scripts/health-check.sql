-- PostgreSQL Performance Health Check
-- Comprehensive database performance assessment

-- =================================================================
-- SECTION 1: GENERAL DATABASE HEALTH
-- =================================================================

\echo '=== POSTGRESQL PERFORMANCE HEALTH CHECK ==='
\echo 'Generated at:' `date`
\echo ''

-- Database version and uptime
\echo '--- Database Version and Uptime ---'
SELECT 
    version() as postgresql_version,
    current_setting('server_version') as server_version,
    pg_postmaster_start_time() as server_start_time,
    EXTRACT(EPOCH FROM (now() - pg_postmaster_start_time())) / 3600 as uptime_hours;

\echo ''

-- =================================================================
-- SECTION 2: PERFORMANCE METRICS
-- =================================================================

\echo '--- Database Performance Overview ---'
SELECT 
    datname as database_name,
    numbackends as active_connections,
    xact_commit as transactions_committed,
    xact_rollback as transactions_rolled_back,
    ROUND((xact_commit * 100.0) / GREATEST(xact_commit + xact_rollback, 1), 2) as commit_ratio_percent,
    blks_read as blocks_read_from_disk,
    blks_hit as blocks_read_from_cache,
    ROUND((blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1), 2) as cache_hit_ratio_percent,
    tup_returned as tuples_returned,
    tup_fetched as tuples_fetched,
    tup_inserted as tuples_inserted,
    tup_updated as tuples_updated,
    tup_deleted as tuples_deleted
FROM pg_stat_database 
WHERE datname = current_database();

\echo ''

-- =================================================================
-- SECTION 3: CONNECTION ANALYSIS
-- =================================================================

\echo '--- Connection Status ---'
SELECT 
    state,
    COUNT(*) as connection_count,
    ROUND(AVG(EXTRACT(EPOCH FROM (now() - state_change))), 2) as avg_state_duration_seconds
FROM pg_stat_activity 
WHERE pid <> pg_backend_pid()
GROUP BY state
ORDER BY connection_count DESC;

\echo ''

\echo '--- Long Running Queries ---'
SELECT 
    pid,
    usename,
    application_name,
    client_addr,
    ROUND(EXTRACT(EPOCH FROM (now() - query_start)), 2) as query_duration_seconds,
    ROUND(EXTRACT(EPOCH FROM (now() - state_change)), 2) as state_duration_seconds,
    state,
    LEFT(query, 100) as query_preview
FROM pg_stat_activity 
WHERE state = 'active' 
AND query_start < now() - interval '5 seconds'
AND pid <> pg_backend_pid()
ORDER BY query_start;

\echo ''

-- =================================================================
-- SECTION 4: TABLE AND INDEX ANALYSIS
-- =================================================================

\echo '--- Table Size and Activity ---'
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
    seq_scan as sequential_scans,
    seq_tup_read as sequential_tuples_read,
    idx_scan as index_scans,
    idx_tup_fetch as index_tuples_fetched,
    n_tup_ins as tuples_inserted,
    n_tup_upd as tuples_updated,
    n_tup_del as tuples_deleted,
    CASE 
        WHEN seq_scan > idx_scan THEN 'Sequential Heavy'
        WHEN idx_scan > seq_scan * 2 THEN 'Index Optimized'
        ELSE 'Balanced'
    END as access_pattern
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;

\echo ''

\echo '--- Index Usage Analysis ---'
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as times_used,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched,
    pg_size_pretty(pg_relation_size(indexname)) as index_size,
    CASE 
        WHEN idx_scan = 0 THEN 'UNUSED - Consider dropping'
        WHEN idx_scan < 10 THEN 'LOW USAGE'
        WHEN idx_scan < 100 THEN 'MODERATE USAGE'
        ELSE 'HIGH USAGE'
    END as usage_category
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

\echo ''

-- =================================================================
-- SECTION 5: QUERY PERFORMANCE (if pg_stat_statements available)
-- =================================================================

\echo '--- Query Performance Analysis ---'
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements') 
        THEN 'pg_stat_statements extension is available'
        ELSE 'pg_stat_statements extension is NOT installed - install for detailed query analysis'
    END as extension_status;

-- Only run if pg_stat_statements is available
\echo '--- Top Queries by Total Time (if pg_stat_statements available) ---'
SELECT 
    calls,
    ROUND(total_exec_time::numeric, 2) as total_exec_time_ms,
    ROUND(mean_exec_time::numeric, 2) as mean_exec_time_ms,
    ROUND((total_exec_time / sum(total_exec_time) OVER()) * 100, 2) as percent_total_time,
    rows,
    LEFT(query, 80) as query_preview
FROM pg_stat_statements 
WHERE total_exec_time > 0
ORDER BY total_exec_time DESC 
LIMIT 10;

\echo ''

-- =================================================================
-- SECTION 6: SYSTEM RESOURCE USAGE
-- =================================================================

\echo '--- Buffer Cache Analysis ---'
SELECT 
    'Database Buffer Cache' as metric_type,
    ROUND((blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1), 2) as hit_ratio_percent,
    CASE 
        WHEN (blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1) >= 95 THEN 'EXCELLENT'
        WHEN (blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1) >= 90 THEN 'GOOD'
        WHEN (blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1) >= 80 THEN 'FAIR'
        ELSE 'POOR - Needs attention'
    END as performance_rating
FROM pg_stat_database 
WHERE datname = current_database();

\echo ''

\echo '--- Lock Analysis ---'
SELECT 
    mode,
    COUNT(*) as lock_count,
    COUNT(CASE WHEN granted = false THEN 1 END) as waiting_locks
FROM pg_locks 
GROUP BY mode
HAVING COUNT(*) > 0
ORDER BY lock_count DESC;

\echo ''

-- =================================================================
-- SECTION 7: CONFIGURATION RECOMMENDATIONS
-- =================================================================

\echo '--- Key Configuration Settings ---'
SELECT 
    name as setting_name,
    setting as current_value,
    unit,
    CASE name
        WHEN 'shared_buffers' THEN 
            CASE 
                WHEN setting::int < 134217728 THEN 'Consider increasing (recommended: 25% of RAM)'
                ELSE 'Reasonable setting'
            END
        WHEN 'effective_cache_size' THEN 'Should be ~75% of available RAM'
        WHEN 'work_mem' THEN 'Adjust based on concurrent connections and query complexity'
        WHEN 'maintenance_work_mem' THEN 'Consider increasing for large operations'
        ELSE 'Review based on workload'
    END as recommendation
FROM pg_settings 
WHERE name IN (
    'shared_buffers', 
    'effective_cache_size', 
    'work_mem', 
    'maintenance_work_mem',
    'max_connections',
    'checkpoint_timeout',
    'wal_buffers'
)
ORDER BY name;

\echo ''

-- =================================================================
-- SECTION 8: HEALTH CHECK SUMMARY
-- =================================================================

\echo '--- Health Check Summary ---'
WITH health_metrics AS (
    SELECT 
        CASE 
            WHEN (blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1) >= 95 THEN 1 
            ELSE 0 
        END as cache_healthy,
        CASE 
            WHEN (xact_commit * 100.0) / GREATEST(xact_commit + xact_rollback, 1) >= 95 THEN 1 
            ELSE 0 
        END as commit_ratio_healthy,
        CASE 
            WHEN numbackends < (SELECT setting::int * 0.8 FROM pg_settings WHERE name = 'max_connections') THEN 1 
            ELSE 0 
        END as connections_healthy
    FROM pg_stat_database 
    WHERE datname = current_database()
)
SELECT 
    cache_healthy + commit_ratio_healthy + connections_healthy as health_score,
    CASE 
        WHEN cache_healthy + commit_ratio_healthy + connections_healthy = 3 THEN 'EXCELLENT - All metrics healthy'
        WHEN cache_healthy + commit_ratio_healthy + connections_healthy = 2 THEN 'GOOD - Minor issues to address'
        WHEN cache_healthy + commit_ratio_healthy + connections_healthy = 1 THEN 'FAIR - Multiple issues need attention'
        ELSE 'POOR - Immediate optimization required'
    END as overall_health_status,
    CASE WHEN cache_healthy = 0 THEN 'Cache hit ratio needs improvement. ' ELSE '' END ||
    CASE WHEN commit_ratio_healthy = 0 THEN 'Transaction rollback ratio is high. ' ELSE '' END ||
    CASE WHEN connections_healthy = 0 THEN 'Connection usage is near maximum. ' ELSE '' END as recommendations
FROM health_metrics;

\echo ''
\echo '=== END OF HEALTH CHECK ==='
\echo 'For detailed analysis, review individual sections above.'
\echo 'Consider running this health check regularly for performance monitoring.'
