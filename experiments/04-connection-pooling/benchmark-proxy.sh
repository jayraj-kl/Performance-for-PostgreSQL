#!/bin/bash

# Connection Pooling Test - Proxy Configuration
# Tests performance using proxy connection pool

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
CLIENTS=100
THREADS=20
TXNS_PER_CLIENT=1000

banner "Starting Proxy Connection Pool Performance Test..." "$POOL_PROXY_HOST:$PGPORT/$POOL_DB"

echo "Configuration:"
echo "- Clients: $CLIENTS"
echo "- Threads: $THREADS"
echo "- Transactions per client: $TXNS_PER_CLIENT"
echo "- Total transactions: $((CLIENTS * TXNS_PER_CLIENT))"
echo ""

# Run the proxy connection pool benchmark
run_pgbench "$POOL_PROXY_HOST" "$POOL_DB" -c "$CLIENTS" -j "$THREADS" -t "$TXNS_PER_CLIENT"

echo ""
echo "Proxy connection pool test completed!"
echo "Check results.md for detailed analysis."
