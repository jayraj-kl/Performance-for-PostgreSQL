-- Replication Lag Monitoring Queries
-- Run these on the read replica to monitor replication status

-- Query 1: Current replication lag
SELECT now() - pg_last_xact_replay_timestamp() AS replication_lag;

-- Query 2: Detailed replication status
SELECT 
    pg_is_in_recovery() as is_replica,
    pg_last_xact_replay_timestamp() as last_replay,
    now() - pg_last_xact_replay_timestamp() as lag,
    pg_last_wal_receive_lsn() as last_received_lsn,
    pg_last_wal_replay_lsn() as last_replayed_lsn;

-- Query 3: Replication lag monitoring over time (run multiple times)
\echo 'Monitoring replication lag - sample every 5 seconds...'
\echo 'Press Ctrl+C to stop'

-- Sample replication lag measurements
SELECT 'Sample 1' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;
SELECT pg_sleep(1);
SELECT 'Sample 2' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;
SELECT pg_sleep(1);
SELECT 'Sample 3' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;
SELECT pg_sleep(1);
SELECT 'Sample 4' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;
SELECT pg_sleep(1);
SELECT 'Sample 5' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;
SELECT pg_sleep(1);
SELECT 'Sample 6' as measurement, now() - pg_last_xact_replay_timestamp() AS replication_lag;

-- Query 4: Average lag calculation
WITH lag_samples AS (
    SELECT now() - pg_last_xact_replay_timestamp() AS lag_interval
)
SELECT 
    EXTRACT(EPOCH FROM lag_interval) * 1000 AS lag_milliseconds,
    lag_interval AS lag_timestamp_format
FROM lag_samples;

-- Query 5: Replica configuration info
SELECT 
    name,
    setting,
    unit,
    category
FROM pg_settings 
WHERE name IN (
    'wal_receiver_timeout',
    'max_standby_streaming_delay',
    'max_standby_archive_delay',
    'hot_standby_feedback',
    'wal_receiver_status_interval'
)
ORDER BY name;

-- Query 6: WAL statistics
SELECT 
    'WAL Receiver Status' as metric_type,
    pg_last_wal_receive_lsn() as received_lsn,
    pg_last_wal_replay_lsn() as replayed_lsn,
    pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() as is_caught_up;
