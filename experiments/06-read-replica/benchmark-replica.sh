#!/bin/bash

# Read Replica Performance Test
# Tests read performance on the read replica

# Read replica connection details
REPLICA_HOST="database-replica-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
REPLICA_PORT="5432"
REPLICA_USER="postgres"
REPLICA_DB="ReadReplica"

echo "Starting Read Replica Performance Test"
echo "====================================="
echo "Target: $REPLICA_HOST:$REPLICA_PORT/$REPLICA_DB"
echo ""

echo "Test Configuration:"
echo "- Transaction Type: select-only"
echo "- Clients: 50"
echo "- Threads: 10"
echo "- Transactions per client: 50,000"
echo "- Total transactions: 2,500,000"
echo ""

echo "Note: Expect some warnings about VACUUM/TRUNCATE on read replica (this is normal)"
echo ""

# Run read performance benchmark on replica
pgbench -c 50 -j 10 -t 50000 -b select-only \
    -h $REPLICA_HOST \
    -p $REPLICA_PORT \
    -U $REPLICA_USER \
    -d $REPLICA_DB

echo ""
echo "Read replica test completed!"
echo "Check results.md for detailed analysis."
echo ""
echo "Don't forget to run replication lag monitoring:"
echo "psql -h $REPLICA_HOST -p $REPLICA_PORT -U $REPLICA_USER -d $REPLICA_DB -f replication-monitoring.sql"
