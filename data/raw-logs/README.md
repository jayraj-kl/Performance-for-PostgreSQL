# Raw Experiment Logs

Unedited `pgbench` / `psql` transcripts captured while running the experiments in June 2025.
Every number in [`EXPERIMENTAL_RESULTS.md`](../../EXPERIMENTAL_RESULTS.md), the per-experiment
`results.md` files and the [paper](../../reports/PostgreSQL_Scaling_Final.pdf) is taken from these logs.

These files are the primary record of the results: do not edit them.

| Log                                                                         | Experiment                                                           |
| --------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| [`base-case/main.txt`](base-case/main.txt)                                   | [01 - Base Case](../../experiments/01-base-case/)                    |
| [`base-case/base-case-optimization.txt`](base-case/base-case-optimization.txt) | [01 - Base Case](../../experiments/01-base-case/)                    |
| [`base-case/indexing-strategies.txt`](base-case/indexing-strategies.txt)     | [02 - Indexing](../../experiments/02-indexing/)                      |
| [`base-case/query-optimization.txt`](base-case/query-optimization.txt)       | [03 - Query Optimization](../../experiments/03-query-optimization/)  |
| [`connection-pooling/main.txt`](connection-pooling/main.txt)                 | [04 - Connection Pooling](../../experiments/04-connection-pooling/)  |
| [`partitioning/main.txt`](partitioning/main.txt)                             | [05 - Partitioning](../../experiments/05-partitioning/)              |
| [`read-replica/main.txt`](read-replica/main.txt)                             | [06 - Read Replica](../../experiments/06-read-replica/)              |
