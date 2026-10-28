# PostgreSQL Performance Experiments - Usage Guide

## Quick Start Guide

This comprehensive PostgreSQL performance experiment suite provides everything needed to analyze, optimize, and monitor PostgreSQL database performance. Follow this guide to get started quickly and effectively.

## Prerequisites

### Environment Requirements

- **PostgreSQL**: Version 9.6+ (tested on 17.4)
- **Operating System**: Linux/macOS (Windows with WSL/PowerShell)
- **Tools**: psql, pgbench, bash shell
- **Permissions**: Database connection and administrative privileges

### Database Configuration

All endpoints, database names, port and user live in one place, [`config/defaults.env`](../config/defaults.env), which holds the reference AWS RDS environment used for the published results. No script contains a hostname.

To target your own servers, override only what differs:

```bash
cp config/local.env.example config/local.env   # git-ignored
# then edit, e.g.
#   PRIMARY_HOST=localhost
#   PGPASSWORD=...        (or use ~/.pgpass)
```

Precedence is **shell environment > `config/local.env` > `config/defaults.env`**, so one-off overrides also work:

```bash
PRIMARY_HOST=localhost scripts/run-all-experiments.sh 01
```

| Key                | Used by                                 |
| ------------------ | --------------------------------------- |
| `PRIMARY_HOST`     | 01, 02, 03, 06 (writes), monitoring     |
| `PARTITION_HOST`   | 05                                      |
| `REPLICA_HOST`     | 06 (reads, replication lag)             |
| `POOL_DIRECT_HOST` | 04 (direct)                             |
| `POOL_PROXY_HOST`  | 04 (RDS Proxy)                          |
| `BASECASE_DB`      | 01, 02, 03                              |
| `POOL_DB`          | 04                                      |
| `PARTITION_DB`     | 05                                      |
| `REPLICA_DB`       | 06                                      |
| `MONITOR_DB`       | connection check, performance monitor   |

## Setup Instructions

### 1. Initial Setup

```bash
# Clone the experiment suite
git clone https://github.com/jayraj-kl/Performance-for-PostgreSQL.git
cd Performance-for-PostgreSQL

# Offline checks: script syntax, experiment layout, dry run of every experiment
scripts/validate.sh

# Test database connection
psql -h your-host -U your-user -d your-db -c "SELECT version();"
```

### 2. Preview Commands (Dry Run)

```bash
# Print every pgbench/psql command that would run, without connecting
DRY_RUN=1 scripts/run-all-experiments.sh
```

## Running Experiments

### Option 1: Run All Experiments (Recommended)

```bash
# Execute complete experiment suite (works from any directory)
scripts/run-all-experiments.sh

# Or only selected experiments, by number prefix
scripts/run-all-experiments.sh 02 05

# Logs and EXPERIMENT_SUMMARY.md are saved to reports/runs/YYYYMMDD_HHMMSS/
# The script exits non-zero if any experiment failed.
```

### Option 2: Run Individual Experiments

Every experiment has a `run.sh` that performs its steps in order:

| Experiment                | `run.sh` steps                                                                                       |
| ------------------------- | ---------------------------------------------------------------------------------------------------- |
| `01-base-case`            | `benchmark.sh` (pgbench init + load test) → `performance-monitoring.sql`                             |
| `02-indexing`             | `index-creation.sql` → `performance-tests.sql` (needs 01's data)                                     |
| `03-query-optimization`   | `setup.sql` → `slow-query-analysis.sql` → `explain-analysis.sql` → `performance-monitoring.sql`      |
| `04-connection-pooling`   | `benchmark-direct.sh` → `benchmark-proxy.sh`                                                         |
| `05-partitioning`         | `table-creation.sql` → `data-generation.sql` → `performance-tests.sql`                               |
| `06-read-replica`         | `setup.sh` → `benchmark-primary.sh` → `benchmark-replica.sh` → `replication-monitoring.sql`          |

```bash
experiments/05-partitioning/run.sh

# Individual steps can still be run on their own
experiments/04-connection-pooling/benchmark-proxy.sh
```

## Monitoring and Analysis

### Real-time Performance Monitoring

```bash
# Start continuous monitoring (60-second intervals for 1 hour)
scripts/performance-monitor.sh 60 3600

# Custom monitoring (30-second intervals for 30 minutes)
scripts/performance-monitor.sh 30 1800

# Results saved to reports/monitoring/performance_monitor_YYYYMMDD_HHMMSS.log*
```

### Health Check Assessment

```bash
# Run comprehensive health check
psql -f scripts/health-check.sql

# Save health check results
psql -f scripts/health-check.sql > reports/health-check-$(date +%Y%m%d).log
```

## Understanding Results

### Experiment Results Structure

Each experiment folder contains:

- **README.md**: Objective, quick results and navigation
- **run.sh**: Entry point that runs the experiment's steps in order
- **\*.sql / \*.sh**: The individual setup, benchmark and analysis steps
- **results.md**: Detailed analysis and findings from the published run

The raw transcripts behind each `results.md` are in [`data/raw-logs/`](../data/raw-logs/).

### Key Performance Metrics

| Metric                     | Good           | Fair           | Poor           | Action                   |
| -------------------------- | -------------- | -------------- | -------------- | ------------------------ |
| **Cache Hit Ratio**        | >95%           | 90-95%         | <90%           | Increase shared_buffers  |
| **TPS (Transactions/sec)** | Baseline + 20% | Baseline ± 10% | Baseline - 20% | Optimize queries/indexes |
| **Average Latency**        | <10ms          | 10-50ms        | >50ms          | Review query performance |
| **Connection Usage**       | <80% max       | 80-90% max     | >90% max       | Implement pooling        |

### Performance Improvement Targets

- **Indexing**: 30-70% query improvement
- **Query Optimization**: 20-50% execution time reduction
- **Connection Pooling**: 15-40% TPS improvement
- **Partitioning**: 50-1000%+ for time-series queries
- **Read Replicas**: 40-300% read throughput improvement

## Troubleshooting

### Common Issues and Solutions

#### Connection Problems

```bash
# Test basic connectivity
pg_isready -h your-host -p 5432

# Check authentication
psql -h your-host -U your-user -d postgres -c "SELECT current_user;"

# Verify database exists
psql -h your-host -U your-user -l
```

#### Permission Issues

```sql
-- Grant necessary permissions
GRANT CONNECT ON DATABASE your_db TO your_user;
GRANT USAGE ON SCHEMA public TO your_user;
GRANT CREATE ON SCHEMA public TO your_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO your_user;
```

#### Performance Issues

```sql
-- Check for blocking queries
SELECT * FROM pg_stat_activity WHERE state = 'active' AND query_start < now() - interval '30 seconds';

-- Check for locks
SELECT * FROM pg_locks WHERE NOT granted;

-- Monitor resource usage
SELECT * FROM pg_stat_database WHERE datname = current_database();
```

### Script Execution Problems

```bash
# Make scripts executable
chmod +x scripts/*.sh experiments/*/*.sh

# Check shell compatibility
bash --version

# Run with explicit bash
bash scripts/run-all-experiments.sh
```

## Customization and Extension

### Adapting for Your Environment

#### Scaling Factors

```bash
# Modify the SCALE / CLIENTS / THREADS / TXNS_PER_CLIENT constants at the top
# of each benchmark script (the committed values reproduce the published results)
# Small dataset (testing): -s 10
# Medium dataset (development): -s 100
# Large dataset (production simulation): -s 1000

pgbench -i -s 100 -h your-host -U your-user -d your-db
```

#### Test Duration

```bash
# Short tests (development): -T 60 (1 minute)
# Standard tests (validation): -T 300 (5 minutes)
# Long tests (production): -T 1800 (30 minutes)

pgbench -T 300 -c 10 -j 2 -h your-host -U your-user -d your-db
```

#### Custom Queries

```sql
-- Add your custom queries to performance tests
-- Example in experiments/*/performance-tests.sql:

\timing on
-- Your custom query here
SELECT COUNT(*) FROM your_table WHERE your_condition;
\timing off
```

### Adding New Experiments

An experiment is any `experiments/NN-name/` folder with a `README.md`, a `results.md` and a `run.sh`. `run-all-experiments.sh` picks it up automatically and `validate.sh` checks the layout.

```bash
mkdir experiments/07-your-experiment/
cp experiments/01-base-case/README.md experiments/07-your-experiment/   # then edit
touch experiments/07-your-experiment/results.md

cat > experiments/07-your-experiment/run.sh << 'EOF'
#!/bin/bash
# Experiment 07 - Your Experiment
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"
require_cmd psql pgbench

run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/setup.sql"
run_pgbench "$PRIMARY_HOST" "$BASECASE_DB" -c 10 -j 2 -T 60
EOF
chmod +x experiments/07-your-experiment/run.sh

# New endpoints or databases go in config/defaults.env
scripts/validate.sh
```

## Best Practices

### Before Running Experiments

1. **Backup your data** - Always backup before making changes
2. **Test environment** - Use non-production environment first
3. **Baseline measurement** - Run base-case experiment first
4. **Single changes** - Test one optimization at a time
5. **Consistent conditions** - Maintain consistent test conditions

### During Experiments

1. **Monitor resources** - Watch CPU, memory, and I/O usage
2. **Record conditions** - Note any concurrent activities
3. **Multiple runs** - Run tests multiple times for consistency
4. **Document changes** - Keep detailed notes of modifications

### After Experiments

1. **Analyze results** - Review all performance metrics
2. **Validate improvements** - Confirm optimizations work as expected
3. **Monitor ongoing** - Set up continuous performance monitoring
4. **Document findings** - Update results.md with insights

## Expected Outcomes

### Performance Improvements by Strategy

| Strategy               | Typical Improvement | Best Case | Applicable Scenarios  |
| ---------------------- | ------------------- | --------- | --------------------- |
| **Indexing**           | 30-70%              | 10x+      | Query-heavy workloads |
| **Query Optimization** | 20-50%              | 5x+       | Complex queries       |
| **Connection Pooling** | 15-40%              | 3x+       | High concurrency      |
| **Partitioning**       | 50-200%             | 1000x+    | Time-series data      |
| **Read Replicas**      | 40-100%             | 10x+      | Read-heavy workloads  |

### Success Indicators

- **Consistent improvements** across multiple test runs
- **No performance regressions** in other areas
- **Stable resource usage** during optimization
- **Measurable business impact** (faster queries, better user experience)

## Support and Next Steps

### Getting Help

1. **Review documentation** - Check experiment-specific README files
2. **Check logs** - Review generated log files for errors
3. **Validate setup** - Ensure environment meets requirements
4. **Test components** - Run individual scripts to isolate issues

### Extending the Framework

1. **Add monitoring dashboards** - Integrate with Grafana/monitoring tools
2. **Automate reporting** - Schedule regular performance reports
3. **CI/CD integration** - Add performance regression testing
4. **Production deployment** - Implement optimizations in production

### Production Checklist

- [ ] All experiments run successfully in test environment
- [ ] Performance improvements validated and documented
- [ ] Monitoring established for ongoing assessment
- [ ] Rollback plan prepared for each optimization
- [ ] Change management process followed
- [ ] Team training completed on new configurations

---

**You're ready to optimize PostgreSQL performance!**

Start with the base case experiment to establish your baseline, then progressively implement optimizations based on your specific workload requirements. Remember to monitor continuously and validate improvements in your production environment.
