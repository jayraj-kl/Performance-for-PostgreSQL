#!/bin/bash

# Read Replica Setup Script
# Initializes the database for read replica performance testing

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
SCALE=100

echo "Setting up Read Replica Performance Test Environment"
echo "=================================================="
echo "Primary Database: $PRIMARY_HOST:$PGPORT/$REPLICA_DB"
echo ""

echo "Step 1: Initializing pgbench schema (scaling factor $SCALE)..."
echo "This will create ~10M records for testing"

# Initialize the database with pgbench
run_pgbench "$PRIMARY_HOST" "$REPLICA_DB" -i -s "$SCALE"

echo ""
echo "Setup completed!"
echo ""
echo "Next steps:"
echo "1. Run benchmark-primary.sh to test write performance"
echo "2. Run benchmark-replica.sh to test read performance"
echo "3. Use replication-monitoring.sql to check replication lag"
echo "4. Review results.md for detailed analysis"
