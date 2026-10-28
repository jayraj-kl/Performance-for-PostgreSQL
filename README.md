# PostgreSQL Performance Optimization Research

_Comprehensive performance testing and optimization strategies for PostgreSQL databases_

[![Paper](https://img.shields.io/badge/Paper-PDF-b31b1b.svg)](reports/PostgreSQL_Scaling_Final.pdf)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17.4-336791.svg?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Cite](https://img.shields.io/badge/Cite-BibTeX-blue.svg)](#citation)

## Project Overview

This repository contains systematic performance experiments and optimizations for PostgreSQL databases, focusing on real-world scenarios and production-ready solutions. It accompanies the paper **"PostgreSQL Scaling: Analysis of Techniques and Use Case Justification"** ([PDF](reports/PostgreSQL_Scaling_Final.pdf)).

## Quick Results Summary

| Experiment             | Key Improvement       | Impact |
| ---------------------- | --------------------- | ------ |
| **Partitioning**       | 1,630x faster queries | 5/5    |
| **Read Replica**       | 12.2x read throughput | 5/5    |
| **Connection Pooling** | 44% better TPS        | 4/5    |
| **Indexing**           | 33% faster lookups    | 4/5    |

## Repository Structure

```
├── EXPERIMENTAL_RESULTS.md      # Master summary of all experiments
├── CITATION.cff                 # Citation metadata ("Cite this repository" on GitHub)
├── config/
│   ├── defaults.env             # Reference environment used for the published results
│   └── local.env.example        # Template for your own endpoints / credentials
├── experiments/                 # One folder per experiment, each with the same layout:
│   │                            #   README.md, results.md, run.sh + its SQL/shell steps
│   ├── 01-base-case/            # Baseline performance measurements
│   ├── 02-indexing/             # Index optimization strategies
│   ├── 03-query-optimization/   # Query tuning techniques
│   ├── 04-connection-pooling/   # Connection pooling analysis
│   ├── 05-partitioning/         # Table partitioning strategies
│   └── 06-read-replica/         # Read replica performance
├── scripts/
│   ├── lib/common.sh            # Shared config loading, logging, pgbench/psql wrappers
│   ├── run-all-experiments.sh   # Runs every experiments/*/run.sh with per-experiment logs
│   ├── performance-monitor.sh   # Continuous metrics collection
│   ├── health-check.sql         # Database health assessment
│   └── validate.sh              # Offline checks (syntax, layout, dry run)
├── data/raw-logs/               # Unedited pgbench/psql transcripts behind every reported number
├── docs/                        # Usage guide
└── reports/                     # Paper (PDF + LaTeX source), figures, generated run reports
```

## Quick Start

1. **Review Results:** Start with [`EXPERIMENTAL_RESULTS.md`](EXPERIMENTAL_RESULTS.md) or the [paper](reports/PostgreSQL_Scaling_Final.pdf)
2. **Configure:** Copy `config/local.env.example` to `config/local.env` and set your endpoints (credentials via `PGPASSWORD` or `~/.pgpass`)
3. **Check:** `scripts/validate.sh`, then `DRY_RUN=1 scripts/run-all-experiments.sh` to print every command without touching a database
4. **Run:** `scripts/run-all-experiments.sh` (all) or `scripts/run-all-experiments.sh 02 05` (selected), from any directory
5. **Inspect:** Logs and a summary are written to `reports/runs/<timestamp>/`

The `pgbench` parameters (scale, clients, threads, transactions) in each experiment are the exact values used for the published results. See [`docs/USAGE_GUIDE.md`](docs/USAGE_GUIDE.md) for details.

## Environment

- **PostgreSQL Version:** 17.4
- **Cloud Provider:** AWS RDS
- **Region:** ap-south-1
- **Benchmark Tool:** pgbench
- **Testing Date:** June 2025

## Key Findings

- **Partitioning provides massive performance gains** for time-series data
- **Read replicas are essential** for read-heavy workloads
- **Connection pooling significantly improves** concurrent performance
- **Proper indexing strategies** are fundamental for query optimization

## Quick Links

- [Research Paper](reports/PostgreSQL_Scaling_Final.pdf) - Complete academic analysis and findings
- [Complete Results Summary](EXPERIMENTAL_RESULTS.md)
- [Raw Experiment Logs](data/raw-logs/)
- [Base Case Performance](experiments/01-base-case/)
- [Partitioning Analysis](experiments/05-partitioning/)
- [Read Replica Testing](experiments/06-read-replica/)

## Citation

If you find this repository or our findings useful in your research or work, please consider citing:

```bibtex
@misc{ladkat2025postgresqlscaling,
  title        = {PostgreSQL Scaling: Analysis of Techniques and Use Case Justification},
  author       = {Ladkat, Jayraj Kiran and Waghodekar, Pranati},
  year         = {2025},
  institution  = {Department of Computer Engineering and Technology, Dr. Vishwanath Karad MIT World Peace University},
  howpublished = {\url{https://github.com/jayraj-kl/Performance-for-PostgreSQL/blob/main/reports/PostgreSQL_Scaling_Final.pdf}}
}
```

To cite the experiment suite and data itself:

```bibtex
@software{ladkat2025performancepostgresql,
  title  = {Performance for PostgreSQL: Reproducible Scaling Experiments on AWS RDS},
  author = {Ladkat, Jayraj Kiran and Waghodekar, Pranati},
  year   = {2025},
  url    = {https://github.com/jayraj-kl/Performance-for-PostgreSQL}
}
```

GitHub also offers APA and BibTeX formats via the **"Cite this repository"** button, generated from [`CITATION.cff`](CITATION.cff).
