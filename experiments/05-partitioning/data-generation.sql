-- Data Generation for Partitioning Tests
-- Generates test data for both partitioned and non-partitioned tables

-- ========================================
-- 1. LARGE EVENTS TABLE (Non-partitioned)
-- ========================================

-- Generate 2 years of event data (1 record per minute)
INSERT INTO large_events (event_time, event_type, data)
SELECT
    generate_series('2023-01-01'::timestamp, '2024-12-31'::timestamp, '1 minute'::interval) as event_time,
    CASE (random() * 3)::int
        WHEN 0 THEN 'login'
        WHEN 1 THEN 'logout'
        WHEN 2 THEN 'purchase'
        ELSE 'view'
    END as event_type,
    ('{"user_id": ' || (random() * 10000)::int || '}')::jsonb as data;

-- Check inserted data count
SELECT 
    'large_events' as table_name,
    COUNT(*) as record_count,
    MIN(event_time) as earliest_event,
    MAX(event_time) as latest_event
FROM large_events;

-- ========================================
-- 2. PARTITIONED EVENTS TABLE (Sample data)
-- ========================================

-- Insert sample data into partitioned table
INSERT INTO partitioned_events (event_time, event_type, data)
VALUES 
    ('2023-02-15 10:30:00', 'login', '{"user_id": 123}'),
    ('2023-02-20 14:45:00', 'purchase', '{"user_id": 456, "amount": 99.99}'),
    ('2023-05-10 09:15:00', 'logout', '{"user_id": 789}'),
    ('2023-03-01 16:20:00', 'view', '{"user_id": 321, "page": "homepage"}');

-- Verify partition distribution
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserted_rows
FROM pg_stat_user_tables
WHERE tablename LIKE 'partitioned_events%'
ORDER BY tablename;

-- ========================================
-- 3. USER ACTIONS TABLE (List partitioning)
-- ========================================

-- Generate sample user actions data
INSERT INTO user_actions (user_id, action_type, action_date)
SELECT 
    (random() * 1000)::int as user_id,
    CASE (random() * 4)::int
        WHEN 0 THEN 'login'
        WHEN 1 THEN 'logout'
        WHEN 2 THEN 'purchase'
        ELSE 'view'
    END as action_type,
    current_date - (random() * 365)::int as action_date
FROM generate_series(1, 10000);

-- Check partition distribution
SELECT 
    'user_actions_login' as partition,
    COUNT(*) as records
FROM user_actions_login
UNION ALL
SELECT 
    'user_actions_purchase' as partition,
    COUNT(*) as records
FROM user_actions_purchase
UNION ALL
SELECT 
    'user_actions_other' as partition,
    COUNT(*) as records
FROM user_actions_other
ORDER BY partition;

-- ========================================
-- 4. USER DATA TABLE (Hash partitioning)
-- ========================================

-- Generate user data for hash partitioning
INSERT INTO user_data (user_id, username, email)
SELECT 
    generate_series(1, 1000) as user_id,
    'user_' || generate_series(1, 1000) as username,
    'user_' || generate_series(1, 1000) || '@example.com' as email;

-- Check hash partition distribution
SELECT 
    'user_data_p0' as partition,
    COUNT(*) as records
FROM user_data_p0
UNION ALL
SELECT 
    'user_data_p1' as partition,
    COUNT(*) as records  
FROM user_data_p1
UNION ALL
SELECT 
    'user_data_p2' as partition,
    COUNT(*) as records
FROM user_data_p2
UNION ALL
SELECT 
    'user_data_p3' as partition,
    COUNT(*) as records
FROM user_data_p3
ORDER BY partition;

-- ========================================
-- SUMMARY STATISTICS
-- ========================================

-- Overall data summary
SELECT 
    'large_events' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('large_events')) as table_size
FROM large_events
UNION ALL
SELECT 
    'partitioned_events' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('partitioned_events')) as table_size
FROM partitioned_events
UNION ALL
SELECT 
    'user_actions' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('user_actions')) as table_size
FROM user_actions
UNION ALL
SELECT 
    'user_data' as table_name,
    COUNT(*) as total_records,
    pg_size_pretty(pg_total_relation_size('user_data')) as table_size
FROM user_data
ORDER BY table_name;
