-- Table Creation for Partitioning Experiments
-- Creates various partitioned and non-partitioned tables for comparison

-- Connect to Partitioned database
\c Partitioned

-- ========================================
-- 1. NON-PARTITIONED TABLE (Baseline)
-- ========================================

-- Large events table without partitioning
CREATE TABLE large_events (
    id BIGSERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL,
    event_type TEXT,
    data JSONB
);

-- ========================================
-- 2. RANGE PARTITIONING (Time-based)
-- ========================================

-- Parent table with range partitioning by event_time
CREATE TABLE partitioned_events (
    id BIGSERIAL,
    event_time TIMESTAMP NOT NULL,
    event_type TEXT,
    data JSONB
) PARTITION BY RANGE (event_time);

-- Q1 2023 partition (Jan-Mar)
CREATE TABLE partitioned_events_2023_q1 PARTITION OF partitioned_events
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

-- Q2 2023 partition (Apr-Jun)
CREATE TABLE partitioned_events_2023_q2 PARTITION OF partitioned_events
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

-- Default partition for overflow data
CREATE TABLE partitioned_events_default PARTITION OF partitioned_events DEFAULT;

-- ========================================
-- 3. LIST PARTITIONING (Action-type based)
-- ========================================

-- Parent table with list partitioning by action_type
CREATE TABLE user_actions (
    action_id SERIAL,
    user_id INT NOT NULL,
    action_type TEXT NOT NULL,
    action_date DATE
) PARTITION BY LIST (action_type);

-- Login actions partition
CREATE TABLE user_actions_login PARTITION OF user_actions 
FOR VALUES IN ('login');

-- Purchase actions partition
CREATE TABLE user_actions_purchase PARTITION OF user_actions 
FOR VALUES IN ('purchase');

-- Other actions partition (logout, view)
CREATE TABLE user_actions_other PARTITION OF user_actions 
FOR VALUES IN ('logout', 'view');

-- ========================================
-- 4. HASH PARTITIONING (Load distribution)
-- ========================================

-- Parent table with hash partitioning by user_id
CREATE TABLE user_data (
    user_id INT NOT NULL,
    username TEXT,
    email TEXT
) PARTITION BY HASH (user_id);

-- Hash partitions (4-way split for even distribution)
CREATE TABLE user_data_p0 PARTITION OF user_data 
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE user_data_p1 PARTITION OF user_data 
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE user_data_p2 PARTITION OF user_data 
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE user_data_p3 PARTITION OF user_data 
FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- ========================================
-- VERIFY TABLE CREATION
-- ========================================

-- List all created tables
\dt

-- Show partition information
SELECT 
    schemaname,
    tablename,
    tableowner,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
