# PostgreSQL Performance Optimization Research

_Comprehensive performance testing and optimization strategies for PostgreSQL databases_

## 🎯 Project Overview

This repository contains systematic performance experiments and optimizations for PostgreSQL databases, focusing on real-world scenarios and production-ready solutions.

## 📊 Quick Results Summary

| Experiment             | Key Improvement       | Impact     |
| ---------------------- | --------------------- | ---------- |
| **Partitioning**       | 1,630x faster queries | ⭐⭐⭐⭐⭐ |
| **Read Replica**       | 12.2x read throughput | ⭐⭐⭐⭐⭐ |
| **Connection Pooling** | 44% better TPS        | ⭐⭐⭐⭐   |
| **Indexing**           | 33% faster lookups    | ⭐⭐⭐⭐   |

## 🗂️ Repository Structure

```
├── EXPERIMENTAL_RESULTS.md     # Master summary of all experiments
├── experiments/                # Individual experiment folders
│   ├── 01-base-case/          # Baseline performance measurements
│   ├── 02-indexing/           # Index optimization strategies
│   ├── 03-query-optimization/ # Query tuning techniques
│   ├── 04-connection-pooling/ # Connection pooling analysis
│   ├── 05-partitioning/       # Table partitioning strategies
│   └── 06-read-replica/       # Read replica performance
├── scripts/                   # Utility and automation scripts
├── docs/                      # Additional documentation
├── data/                      # Raw performance data
└── reports/                   # Generated reports
```

## 🚀 Quick Start

1. **Review Results:** Start with [`EXPERIMENTAL_RESULTS.md`](EXPERIMENTAL_RESULTS.md)
2. **Explore Experiments:** Navigate to specific experiment folders
3. **Run Tests:** Use scripts in the `scripts/` directory
4. **Generate Reports:** Check the `reports/` folder for summaries

## 🛠️ Environment

- **PostgreSQL Version:** 17.4
- **Cloud Provider:** AWS RDS
- **Region:** ap-south-1
- **Benchmark Tool:** pgbench
- **Testing Date:** June 2025

## 📈 Key Findings

- **Partitioning provides massive performance gains** for time-series data
- **Read replicas are essential** for read-heavy workloads
- **Connection pooling significantly improves** concurrent performance
- **Proper indexing strategies** are fundamental for query optimization

## 🔗 Quick Links

- [📄 Research Paper](reports/PostgreSQL_Scaling_Final.pdf) - Complete academic analysis and findings
- [Complete Results Summary](EXPERIMENTAL_RESULTS.md)
- [Base Case Performance](experiments/01-base-case/)
- [Partitioning Analysis](experiments/05-partitioning/)
- [Read Replica Testing](experiments/06-read-replica/)
