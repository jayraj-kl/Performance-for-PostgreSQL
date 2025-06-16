#!/bin/bash

# Read Replica Setup Script
# Initializes the database for read replica performance testing

# Primary database connection details
PRIMARY_HOST="database-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
PRIMARY_PORT="5432"
PRIMARY_USER="postgres"
PRIMARY_DB="ReadReplica"

echo "Setting up Read Replica Performance Test Environment"
echo "=================================================="
echo "Primary Database: $PRIMARY_HOST:$PRIMARY_PORT/$PRIMARY_DB"
echo ""

echo "Step 1: Connecting to primary database..."
echo "Command: psql -h $PRIMARY_HOST -p $PRIMARY_PORT -U $PRIMARY_USER -d $PRIMARY_DB"
echo ""

echo "Step 2: Initializing pgbench schema (scaling factor 100)..."
echo "This will create ~10M records for testing"

# Initialize the database with pgbench
pgbench -i -s 100 \
    -h $PRIMARY_HOST \
    -p $PRIMARY_PORT \
    -U $PRIMARY_USER \
    -d $PRIMARY_DB

echo ""
echo "Setup completed!"
echo ""
echo "Next steps:"
echo "1. Run benchmark-primary.sh to test write performance"
echo "2. Run benchmark-replica.sh to test read performance"
echo "3. Use replication-monitoring.sql to check replication lag"
echo "4. Review results.md for detailed analysis"
