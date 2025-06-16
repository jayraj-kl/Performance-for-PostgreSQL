# Base Case Performance Testing

**Objective:** Establish baseline PostgreSQL performance metrics  
**Date:** June 2025  
**Duration:** ~45 minutes (30s setup + benchmark execution)

## 🎯 Quick Results

- **Baseline TPS:** 411.72 transactions/second
- **Average Latency:** 48.577 ms
- **Success Rate:** 100% (0 failed transactions)
- **Recommendation:** Solid baseline for comparison

## 📁 Files in this Folder

- [`setup.sql`](setup.sql) - Database initialization commands
- [`benchmark.sh`](benchmark.sh) - pgbench test execution
- [`results.md`](results.md) - Detailed performance analysis
- [`performance-monitoring.sql`](performance-monitoring.sql) - Statistics queries

## 🔗 Quick Navigation

- [Detailed Results](results.md)
- [Back to Main Results](../../EXPERIMENTAL_RESULTS.md#base-case-performance)
- [Next: Indexing Strategies](../02-indexing/)

## 📊 Key Metrics at a Glance

| Metric                  | Value      |
| ----------------------- | ---------- |
| Scaling Factor          | 100        |
| Concurrent Clients      | 20         |
| Transactions per Client | 10,000     |
| Total Transactions      | 200,000    |
| **TPS**                 | **411.72** |
