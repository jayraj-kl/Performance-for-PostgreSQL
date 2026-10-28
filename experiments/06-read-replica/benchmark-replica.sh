#!/bin/bash

# Read Replica Performance Test
# Tests read performance on the read replica

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
CLIENTS=50
THREADS=10
TXNS_PER_CLIENT=50000
BUILTIN=select-only

banner "Starting Read Replica Performance Test" "$REPLICA_HOST:$PGPORT/$REPLICA_DB"
echo ""

echo "Test Configuration:"
echo "- Transaction Type: $BUILTIN"
echo "- Clients: $CLIENTS"
echo "- Threads: $THREADS"
echo "- Transactions per client: $TXNS_PER_CLIENT"
echo "- Total transactions: $((CLIENTS * TXNS_PER_CLIENT))"
echo ""

echo "Note: Expect some warnings about VACUUM/TRUNCATE on read replica (this is normal)"
echo ""

# Run read performance benchmark on replica
run_pgbench "$REPLICA_HOST" "$REPLICA_DB" -c "$CLIENTS" -j "$THREADS" -t "$TXNS_PER_CLIENT" -b "$BUILTIN"

echo ""
echo "Read replica test completed!"
echo "Check results.md for detailed analysis."
echo ""
echo "Don't forget to run replication lag monitoring:"
echo "psql -h $REPLICA_HOST -p $PGPORT -U $PGUSER -d $REPLICA_DB -f replication-monitoring.sql"
