#!/bin/bash
# PostgreSQL Performance Experiments - Master Run Script
# Executes all experiments in sequence with comprehensive logging

# Configuration
export PGHOST="database-1.cxa0i80mysid.ap-south-1.rds.amazonaws.com"
export PGPORT="5432"
export PGUSER="postgres"
export PGDATABASE="postgres"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create results directory
RESULTS_DIR="./reports/$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$RESULTS_DIR"

log "PostgreSQL Performance Experiments - Starting Full Suite"
log "Results will be saved to: $RESULTS_DIR"

# Test database connection
log "Testing database connection..."
if psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -c "SELECT version();" > /dev/null 2>&1; then
    success "Database connection established"
else
    error "Cannot connect to database. Please check configuration."
    exit 1
fi

# Experiment 1: Base Case
log "=== Running Experiment 1: Base Case ==="
cd experiments/01-base-case/
if [ -f "benchmark.sh" ]; then
    chmod +x benchmark.sh
    ./benchmark.sh 2>&1 | tee "$RESULTS_DIR/01-base-case.log"
    success "Base case experiment completed"
else
    warning "Base case benchmark script not found"
fi
cd ../..

# Experiment 2: Indexing
log "=== Running Experiment 2: Indexing ==="
cd experiments/02-indexing/
if [ -f "performance-tests.sql" ]; then
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f performance-tests.sql 2>&1 | tee "$RESULTS_DIR/02-indexing.log"
    success "Indexing experiment completed"
else
    warning "Indexing test script not found"
fi
cd ../..

# Experiment 3: Query Optimization
log "=== Running Experiment 3: Query Optimization ==="
cd experiments/03-query-optimization/
if [ -f "setup.sql" ]; then
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f setup.sql 2>&1 | tee "$RESULTS_DIR/03-query-setup.log"
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f slow-query-analysis.sql 2>&1 | tee "$RESULTS_DIR/03-query-analysis.log"
    success "Query optimization analysis completed"
else
    warning "Query optimization scripts not found"
fi
cd ../..

# Experiment 4: Connection Pooling
log "=== Running Experiment 4: Connection Pooling ==="
cd experiments/04-connection-pooling/
if [ -f "benchmark-direct.sh" ]; then
    chmod +x benchmark-direct.sh benchmark-proxy.sh
    ./benchmark-direct.sh 2>&1 | tee "$RESULTS_DIR/04-connection-direct.log"
    ./benchmark-proxy.sh 2>&1 | tee "$RESULTS_DIR/04-connection-proxy.log"
    success "Connection pooling experiments completed"
else
    warning "Connection pooling scripts not found"
fi
cd ../..

# Experiment 5: Partitioning
log "=== Running Experiment 5: Partitioning ==="
cd experiments/05-partitioning/
if [ -f "table-creation.sql" ]; then
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f table-creation.sql 2>&1 | tee "$RESULTS_DIR/05-partitioning-setup.log"
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f performance-tests.sql 2>&1 | tee "$RESULTS_DIR/05-partitioning-tests.log"
    success "Partitioning experiment completed"
else
    warning "Partitioning scripts not found"
fi
cd ../..

# Experiment 6: Read Replica
log "=== Running Experiment 6: Read Replica ==="
cd experiments/06-read-replica/
if [ -f "benchmark-primary.sh" ]; then
    chmod +x benchmark-primary.sh benchmark-replica.sh
    ./benchmark-primary.sh 2>&1 | tee "$RESULTS_DIR/06-replica-primary.log"
    # Note: Replica benchmark requires replica endpoint
    warning "Replica benchmark requires separate endpoint configuration"
    success "Read replica primary testing completed"
else
    warning "Read replica scripts not found"
fi
cd ../..

# Generate summary report
log "=== Generating Summary Report ==="
cat > "$RESULTS_DIR/EXPERIMENT_SUMMARY.md" << EOF
# PostgreSQL Performance Experiments - Execution Summary

**Execution Date**: $(date)
**Environment**: $PGHOST:$PGPORT
**Database**: $PGDATABASE

## Experiments Executed

1. **Base Case**: Baseline performance measurement
2. **Indexing**: Index optimization strategies
3. **Query Optimization**: Query analysis and tuning
4. **Connection Pooling**: Connection management optimization
5. **Partitioning**: Table partitioning strategies
6. **Read Replica**: Read scaling with replicas

## Log Files

- \`01-base-case.log\` - Base case benchmark results
- \`02-indexing.log\` - Index performance tests
- \`03-query-setup.log\` - Query optimization setup
- \`03-query-analysis.log\` - Query analysis results
- \`04-connection-direct.log\` - Direct connection benchmark
- \`04-connection-proxy.log\` - Pooled connection benchmark
- \`05-partitioning-setup.log\` - Partitioning table setup
- \`05-partitioning-tests.log\` - Partitioning performance tests
- \`06-replica-primary.log\` - Primary database tests

## Next Steps

1. Review individual log files for detailed results
2. Compare performance metrics across experiments
3. Implement optimization strategies based on findings
4. Schedule regular performance monitoring

Generated by: PostgreSQL Performance Experiments Suite
EOF

success "All experiments completed successfully!"
log "Results saved to: $RESULTS_DIR"
log "Review EXPERIMENT_SUMMARY.md for overview"

# Display quick summary
echo
echo "=== QUICK SUMMARY ==="
echo "Total experiments run: 6"
echo "Results directory: $RESULTS_DIR"
echo "Log files generated: $(ls -1 "$RESULTS_DIR"/*.log 2>/dev/null | wc -l)"
echo "Summary report: $RESULTS_DIR/EXPERIMENT_SUMMARY.md"
echo
log "Experiment suite execution completed!"
