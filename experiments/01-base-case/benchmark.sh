#!/bin/bash

# Base Case Performance Benchmark
# Establishes baseline PostgreSQL performance metrics

source "$(dirname "${BASH_SOURCE[0]}")/../../scripts/lib/common.sh"
require_cmd pgbench

# pgbench parameters used for the published results
SCALE=100
CLIENTS=20
THREADS=5
TXNS_PER_CLIENT=10000

banner "Starting Base Case Performance Benchmark..." "$PRIMARY_HOST:$PGPORT/$BASECASE_DB"

# Step 1: Initialize database with pgbench schema
echo "Step 1: Initializing database (scaling factor $SCALE)..."
run_pgbench "$PRIMARY_HOST" "$BASECASE_DB" -i -s "$SCALE"

echo ""
echo "Step 2: Running performance benchmark..."
echo "Configuration: $CLIENTS clients, $THREADS threads, $TXNS_PER_CLIENT transactions per client"

# Step 2: Run the main performance benchmark
run_pgbench "$PRIMARY_HOST" "$BASECASE_DB" -c "$CLIENTS" -j "$THREADS" -t "$TXNS_PER_CLIENT"

echo ""
echo "Base case benchmark completed!"
echo "Check results.md for detailed analysis."
