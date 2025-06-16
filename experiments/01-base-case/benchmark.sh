#!/bin/bash

# Base Case Performance Benchmark
# Establishes baseline PostgreSQL performance metrics

# Database connection details
DB_HOST="database-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
DB_PORT="5432"
DB_USER="postgres"
DB_NAME="BaseCase"

echo "Starting Base Case Performance Benchmark..."
echo "Target: $DB_HOST:$DB_PORT/$DB_NAME"
echo "============================================"

# Step 1: Initialize database with pgbench schema
echo "Step 1: Initializing database (scaling factor 100)..."
pgbench -i -s 100 \
    -h $DB_HOST \
    -p $DB_PORT \
    -U $DB_USER \
    -d $DB_NAME

echo ""
echo "Step 2: Running performance benchmark..."
echo "Configuration: 20 clients, 5 threads, 10,000 transactions per client"

# Step 2: Run the main performance benchmark  
pgbench -c 20 -j 5 -t 10000 \
    -h $DB_HOST \
    -p $DB_PORT \
    -U $DB_USER \
    -d $DB_NAME

echo ""
echo "Base case benchmark completed!"
echo "Check results.md for detailed analysis."
