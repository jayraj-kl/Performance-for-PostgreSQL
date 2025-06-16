#!/bin/bash

# Primary Database Write Performance Test
# Tests write performance on the primary database

# Primary database connection details
PRIMARY_HOST="database-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
PRIMARY_PORT="5432"
PRIMARY_USER="postgres"
PRIMARY_DB="ReadReplica"

echo "Starting Primary Database Write Performance Test"
echo "=============================================="
echo "Target: $PRIMARY_HOST:$PRIMARY_PORT/$PRIMARY_DB"
echo ""

echo "Test Configuration:"
echo "- Transaction Type: simple-update"
echo "- Clients: 20"
echo "- Threads: 5"
echo "- Transactions per client: 10,000"
echo "- Total transactions: 200,000"
echo ""

# Run write performance benchmark on primary
pgbench -c 20 -j 5 -t 10000 -b simple-update \
    -h $PRIMARY_HOST \
    -p $PRIMARY_PORT \
    -U $PRIMARY_USER \
    -d $PRIMARY_DB

echo ""
echo "Primary database write test completed!"
echo "Check results.md for detailed analysis."
