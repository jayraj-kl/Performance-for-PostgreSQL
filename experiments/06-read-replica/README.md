# Read Replica Performance Experiment

**Objective:** Evaluate read replica performance vs. primary database for read-heavy workloads  
**Date:** June 2025  
**Duration:** ~45 minutes (setup + testing)

## 🎯 Quick Results

- **Read Replica TPS:** 7,040.29 (12.2x faster than primary writes)
- **Primary Write TPS:** 575.20
- **Read Latency:** 7.102 ms (79% lower than write latency)
- **Replication Lag:** <4ms average
- **Recommendation:** Essential for read-heavy workloads

## 📁 Files in this Folder

- [`README.md`](README.md) - This overview
- [`setup.sh`](setup.sh) - Database initialization script
- [`benchmark-primary.sh`](benchmark-primary.sh) - Primary database tests
- [`benchmark-replica.sh`](benchmark-replica.sh) - Read replica tests
- [`replication-monitoring.sql`](replication-monitoring.sql) - Lag monitoring queries
- [`results.md`](results.md) - Detailed analysis and comparison

## 🔗 Quick Navigation

- [Detailed Results](results.md)
- [Back to Main Results](../../EXPERIMENTAL_RESULTS.md#read-replica-performance)
- [Previous: Partitioning](../05-partitioning/)

## 📊 Performance Comparison

| Metric         | Primary (Writes)  | Read Replica (Reads) | Ratio            |
| -------------- | ----------------- | -------------------- | ---------------- |
| **TPS**        | 575.20            | 7,040.29             | **12.2x faster** |
| **Latency**    | 34.77 ms          | 7.102 ms             | **4.9x lower**   |
| **Throughput** | 200K transactions | 2.5M transactions    | **12.5x higher** |

## 🎯 Key Findings

- Massive read throughput improvement (12x)
- Excellent replication lag (<4ms)
- Read workload isolation from write workload
- High availability and disaster recovery benefits
