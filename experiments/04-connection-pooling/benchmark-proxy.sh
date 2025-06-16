#!/bin/bash

# Connection Pooling Test - Proxy Configuration
# Tests performance using proxy connection pool

# Database connection details - Proxy
DB_HOST="connection-pool-proxy.proxy-cxa0i80mysid.ap-south-1.rds.amazonaws.com"
DB_PORT="5432"
DB_USER="postgres"
DB_NAME="ConnectionPool"

echo "Starting Proxy Connection Pool Performance Test..."
echo "Target: $DB_HOST:$DB_PORT/$DB_NAME"
echo "=========================================="

echo "Configuration:"
echo "- Clients: 100"
echo "- Threads: 20" 
echo "- Transactions per client: 1,000"
echo "- Total transactions: 100,000"
echo ""

# Run the proxy connection pool benchmark
pgbench -h $DB_HOST -U $DB_USER -d $DB_NAME -c 100 -j 20 -t 1000

echo ""
echo "Proxy connection pool test completed!"
echo "Check results.md for detailed analysis."
