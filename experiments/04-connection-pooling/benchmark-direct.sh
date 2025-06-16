#!/bin/bash

# Connection Pooling Test - Direct Configuration  
# Tests performance using direct connection pool

# Database connection details - Direct
DB_HOST="database-connection-pool.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
DB_PORT="5432"
DB_USER="postgres"
DB_NAME="ConnectionPool"

echo "Starting Direct Connection Pool Performance Test..."
echo "Target: $DB_HOST:$DB_PORT/$DB_NAME"
echo "=========================================="

echo "Configuration:"
echo "- Clients: 100"
echo "- Threads: 20"
echo "- Transactions per client: 1,000" 
echo "- Total transactions: 100,000"
echo ""

# Run the direct connection pool benchmark
pgbench -h $DB_HOST -U $DB_USER -d $DB_NAME -c 100 -j 20 -t 1000

echo ""
echo "Direct connection pool test completed!"
echo "Check results.md for detailed analysis."
