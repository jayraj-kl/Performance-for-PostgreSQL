# Partitioning Strategies Experiment

**Objective:** Demonstrate the performance impact of table partitioning strategies
**Date:** June 2025
**Duration:** ~60 minutes (setup + testing)

## Quick Results

- **Date Range Query Improvement:** 1,630x faster (34.2ms → 0.021ms)
- **Partition Pruning:** Eliminates unnecessary data scans
- **Cross-partition Performance:** Efficient multi-partition queries
- **Recommendation:** Essential for large time-series datasets

## Files in this Folder

- [`run.sh`](run.sh) - Runs this experiment end to end (also invoked by `scripts/run-all-experiments.sh`)
- [`README.md`](README.md) - This overview
- [`table-creation.sql`](table-creation.sql) - Partition table setup
- [`data-generation.sql`](data-generation.sql) - Test data creation
- [`performance-tests.sql`](performance-tests.sql) - Benchmark queries
- [`results.md`](results.md) - Detailed analysis and comparison

## Quick Navigation

- [Detailed Results](results.md)
- [Back to Main Results](../../EXPERIMENTAL_RESULTS.md#partitioning-strategies)
- [Previous: Connection Pooling](../04-connection-pooling/)
- [Next: Read Replica](../06-read-replica/)

## Performance Impact

| Query Type          | Non-Partitioned | Partitioned | Improvement       |
| ------------------- | --------------- | ----------- | ----------------- |
| **Date Range**      | 34.227 ms       | 0.021 ms    | **1,630x faster** |
| **Cross-Partition** | N/A             | 0.042 ms    | Efficient scan    |

## Partitioning Types Tested

- **Range Partitioning:** Time-based quarterly partitions
- **List Partitioning:** Action-type based partitions
- **Hash Partitioning:** User-ID based load distribution

## Key Findings

- Massive performance gains for time-series queries
- Partition pruning eliminates unnecessary data access
- Different partition strategies suit different access patterns
- Minimal overhead for cross-partition queries
