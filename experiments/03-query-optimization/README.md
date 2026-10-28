# Query Optimization Experiment

## Objective

Analyze and optimize PostgreSQL query performance using statistical analysis and execution plan examination.

## Key Components

- **pg_stat_statements**: Query performance statistics
- **EXPLAIN ANALYZE**: Detailed execution plan analysis
- **Slow query logging**: Identification of performance bottlenecks
- **Index usage monitoring**: Optimization of data access patterns

## Quick Results

- Identified queries with >1 second execution time
- Analyzed buffer cache hit ratios
- Monitored index usage efficiency
- Established performance optimization workflow

## Files

- `run.sh` - Runs this experiment end to end (also invoked by `scripts/run-all-experiments.sh`)
- `setup.sql` - Enable performance monitoring extensions
- `slow-query-analysis.sql` - Query performance analysis scripts
- `explain-analysis.sql` - Execution plan examination queries
- `performance-monitoring.sql` - Ongoing performance tracking
- `results.md` - Detailed experiment results and findings

## Usage

1. Run setup to enable monitoring
2. Execute analysis queries to identify bottlenecks
3. Use EXPLAIN ANALYZE for detailed query examination
4. Monitor performance metrics regularly

## Performance Targets

- Buffer Hit Ratio: >95%
- Index Usage: >80% of queries
- Average Query Time: <100ms
- Connection Time: <50ms
