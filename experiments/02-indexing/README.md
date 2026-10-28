# Indexing Strategies Experiment

**Objective:** Analyze the impact of different indexing strategies on query performance
**Date:** June 2025
**Duration:** ~20 minutes

## Quick Results

- **Point Lookup Improvement:** 33% faster with custom index
- **Range Scan Performance:** 12,900% slower without proper index
- **Index Usage:** 400,000+ scans on primary key indexes
- **Recommendation:** Essential for query optimization

## Files in this Folder

- [`run.sh`](run.sh) - Runs this experiment end to end (also invoked by `scripts/run-all-experiments.sh`)
- [`README.md`](README.md) - This overview
- [`index-creation.sql`](index-creation.sql) - Index creation commands
- [`performance-tests.sql`](performance-tests.sql) - Query performance tests
- [`results.md`](results.md) - Detailed analysis and benchmarks

## Quick Navigation

- [Detailed Results](results.md)
- [Back to Main Results](../../EXPERIMENTAL_RESULTS.md#indexing-strategies)
- [Previous: Base Case](../01-base-case/)
- [Next: Query Optimization](../03-query-optimization/)

## Key Performance Comparison

| Query Type                | Without Index | With Index | Improvement     |
| ------------------------- | ------------- | ---------- | --------------- |
| **Point Lookup (PK)**     | -             | 0.058 ms   | Baseline        |
| **Point Lookup (Custom)** | -             | 0.039 ms   | **33% faster**  |
| **Range Scan**            | 3,737 ms      | -          | **Needs index** |

## Key Findings

- Custom indexes provide measurable performance improvements
- Unindexed columns require full table scans (3.7 seconds vs. milliseconds)
- Index usage statistics help identify optimization opportunities
- Buffer efficiency dramatically improves with proper indexing
