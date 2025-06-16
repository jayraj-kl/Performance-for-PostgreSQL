# Connection Pooling Performance Experiment

**Objective:** Compare performance between proxy and direct connection pooling strategies  
**Date:** June 2025  
**Duration:** ~30 minutes

## 🎯 Quick Results

- **Proxy Pool TPS:** 121.44 (44% better than direct)
- **Direct Pool TPS:** 84.05
- **Latency Improvement:** 44% lower with proxy pooling
- **Recommendation:** Use proxy connection pooling for better performance

## 📁 Files in this Folder

- [`README.md`](README.md) - This overview
- [`benchmark-proxy.sh`](benchmark-proxy.sh) - Proxy pool benchmark script
- [`benchmark-direct.sh`](benchmark-direct.sh) - Direct pool benchmark script
- [`results.md`](results.md) - Detailed analysis and comparison

## 🔗 Quick Navigation

- [Detailed Results](results.md)
- [Back to Main Results](../../EXPERIMENTAL_RESULTS.md#connection-pooling)
- [Previous: Query Optimization](../03-query-optimization/)
- [Next: Partitioning](../05-partitioning/)

## 📊 Performance Comparison

| Metric              | Proxy Pool | Direct Pool | Improvement |
| ------------------- | ---------- | ----------- | ----------- |
| **TPS**             | 121.44     | 84.05       | **+44.5%**  |
| **Latency**         | 823 ms     | 1,190 ms    | **-30.8%**  |
| **Connection Time** | 119 ms     | 1,023 ms    | **-88.4%**  |

## 🎯 Key Findings

- Proxy connection pooling significantly outperforms direct pooling
- Connection overhead is dramatically reduced with proxy setup
- High concurrency scenarios benefit most from connection pooling
- Both configurations achieved 100% success rate
