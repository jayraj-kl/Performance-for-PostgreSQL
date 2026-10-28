#!/bin/bash

# Primary Database Write Performance Test
# Tests write performance on the primary database

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
CLIENTS=20
THREADS=5
TXNS_PER_CLIENT=10000
BUILTIN=simple-update

banner "Starting Primary Database Write Performance Test" "$PRIMARY_HOST:$PGPORT/$REPLICA_DB"
echo ""

echo "Test Configuration:"
echo "- Transaction Type: $BUILTIN"
echo "- Clients: $CLIENTS"
echo "- Threads: $THREADS"
echo "- Transactions per client: $TXNS_PER_CLIENT"
echo "- Total transactions: $((CLIENTS * TXNS_PER_CLIENT))"
echo ""

# Run write performance benchmark on primary
run_pgbench "$PRIMARY_HOST" "$REPLICA_DB" -c "$CLIENTS" -j "$THREADS" -t "$TXNS_PER_CLIENT" -b "$BUILTIN"

echo ""
echo "Primary database write test completed!"
echo "Check results.md for detailed analysis."
