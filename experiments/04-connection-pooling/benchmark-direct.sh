#!/bin/bash

# Connection Pooling Test - Direct Configuration
# Tests performance using direct connection pool

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
CLIENTS=100
THREADS=20
TXNS_PER_CLIENT=1000

banner "Starting Direct Connection Pool Performance Test..." "$POOL_DIRECT_HOST:$PGPORT/$POOL_DB"

echo "Configuration:"
echo "- Clients: $CLIENTS"
echo "- Threads: $THREADS"
echo "- Transactions per client: $TXNS_PER_CLIENT"
echo "- Total transactions: $((CLIENTS * TXNS_PER_CLIENT))"
echo ""

# Run the direct connection pool benchmark
run_pgbench "$POOL_DIRECT_HOST" "$POOL_DB" -c "$CLIENTS" -j "$THREADS" -t "$TXNS_PER_CLIENT"

echo ""
echo "Direct connection pool test completed!"
echo "Check results.md for detailed analysis."
