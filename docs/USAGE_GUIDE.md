# PostgreSQL Performance Experiments - Usage Guide

## 🚀 Quick Start Guide

This comprehensive PostgreSQL performance experiment suite provides everything needed to analyze, optimize, and monitor PostgreSQL database performance. Follow this guide to get started quickly and effectively.

## 📋 Prerequisites

### Environment Requirements

- **PostgreSQL**: Version 9.6+ (tested on 17.4)
- **Operating System**: Linux/macOS (Windows with WSL/PowerShell)
- **Tools**: psql, pgbench, bash shell
- **Permissions**: Database connection and administrative privileges

### Database Configuration

Update connection parameters in scripts:

```bash
export PGHOST="your-database-host"
export PGPORT="5432"
export PGUSER="your-username"
export PGDATABASE="your-database"
```

## 🔧 Setup Instructions

### 1. Initial Setup

```bash
# Clone or download the experiment suite
cd c:\Users\Lenovo\RP-postgres\

# Make scripts executable (Linux/macOS)
chmod +x scripts/*.sh experiments/*/*.sh

# Test database connection
psql -h your-host -U your-user -d your-db -c "SELECT version();"
```

### 2. Configure Environment

```bash
# Edit connection parameters in scripts
# Update PGHOST, PGPORT, PGUSER, PGDATABASE in:
# - scripts/run-all-experiments.sh
# - scripts/performance-monitor.sh
# - experiments/*/benchmark.sh
```

## 📊 Running Experiments

### Option 1: Run All Experiments (Recommended)

```bash
# Execute complete experiment suite
cd scripts/
./run-all-experiments.sh

# Results will be saved to ./reports/YYYYMMDD_HHMMSS/
```

### Option 2: Run Individual Experiments

```bash
# Base Case Performance
cd experiments/01-base-case/
psql -f setup.sql
./benchmark.sh

# Indexing Optimization
cd experiments/02-indexing/
psql -f index-creation.sql
psql -f performance-tests.sql

# Query Optimization
cd experiments/03-query-optimization/
psql -f setup.sql
psql -f slow-query-analysis.sql

# Connection Pooling
cd experiments/04-connection-pooling/
./benchmark-direct.sh
./benchmark-proxy.sh

# Partitioning
cd experiments/05-partitioning/
psql -f table-creation.sql
psql -f performance-tests.sql

# Read Replica
cd experiments/06-read-replica/
./setup.sh
./benchmark-primary.sh
# Configure replica endpoint for benchmark-replica.sh
```

## 📈 Monitoring and Analysis

### Real-time Performance Monitoring

```bash
# Start continuous monitoring (60-second intervals for 1 hour)
cd scripts/
./performance-monitor.sh 60 3600

# Custom monitoring (30-second intervals for 30 minutes)
./performance-monitor.sh 30 1800

# Results saved to ./reports/performance_monitor_YYYYMMDD_HHMMSS.log*
```

### Health Check Assessment

```bash
# Run comprehensive health check
psql -f scripts/health-check.sql

# Save health check results
psql -f scripts/health-check.sql > reports/health-check-$(date +%Y%m%d).log
```

## 📝 Understanding Results

### Experiment Results Structure

Each experiment produces:

- **setup.sql**: Database initialization scripts
- **benchmark.sh**: Performance testing automation
- **results.md**: Detailed analysis and findings
- **performance-monitoring.sql**: Ongoing monitoring queries

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

## 🔍 Troubleshooting

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

## 📊 Customization and Extension

### Adapting for Your Environment

#### Scaling Factors

```bash
# Modify pgbench scaling in benchmark scripts
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

```bash
# Create new experiment folder
mkdir experiments/07-your-experiment/

# Copy template structure
cp experiments/01-base-case/README.md experiments/07-your-experiment/
# Modify README.md for your experiment

# Create experiment files
touch experiments/07-your-experiment/setup.sql
touch experiments/07-your-experiment/benchmark.sh
touch experiments/07-your-experiment/results.md
```

## 📈 Best Practices

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

## 🎯 Expected Outcomes

### Performance Improvements by Strategy

| Strategy               | Typical Improvement | Best Case | Applicable Scenarios  |
| ---------------------- | ------------------- | --------- | --------------------- |
| **Indexing**           | 30-70%              | 10x+      | Query-heavy workloads |
| **Query Optimization** | 20-50%              | 5x+       | Complex queries       |
| **Connection Pooling** | 15-40%              | 3x+       | High concurrency      |
| **Partitioning**       | 50-200%             | 1000x+    | Time-series data      |
| **Read Replicas**      | 40-100%             | 10x+      | Read-heavy workloads  |

### Success Indicators

- ✅ **Consistent improvements** across multiple test runs
- ✅ **No performance regressions** in other areas
- ✅ **Stable resource usage** during optimization
- ✅ **Measurable business impact** (faster queries, better user experience)

## 📞 Support and Next Steps

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

**🎉 You're ready to optimize PostgreSQL performance!**

Start with the base case experiment to establish your baseline, then progressively implement optimizations based on your specific workload requirements. Remember to monitor continuously and validate improvements in your production environment.
