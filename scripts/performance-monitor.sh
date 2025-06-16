#!/bin/bash
# PostgreSQL Performance Monitoring Script
# Continuous monitoring of key performance metrics

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

# Configuration
INTERVAL=${1:-60}  # Monitoring interval in seconds (default: 60)
DURATION=${2:-3600}  # Total monitoring duration in seconds (default: 1 hour)

echo -e "${BLUE}PostgreSQL Performance Monitor${NC}"
echo "Monitoring interval: ${INTERVAL}s"
echo "Total duration: ${DURATION}s ($(($DURATION/60)) minutes)"
echo "Database: $PGHOST:$PGPORT/$PGDATABASE"
echo "Started at: $(date)"
echo

# Create monitoring log
LOG_FILE="./reports/performance_monitor_$(date +'%Y%m%d_%H%M%S').log"
mkdir -p ./reports

# Function to get performance metrics
get_metrics() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    # Database performance query
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -t -A -F',' << EOF
SELECT 
    '$timestamp' as timestamp,
    datname,
    ROUND((blks_hit * 100.0) / GREATEST(blks_hit + blks_read, 1), 2) AS cache_hit_ratio,
    tup_returned,
    tup_fetched,
    tup_inserted,
    tup_updated,
    tup_deleted,
    conflicts,
    temp_files,
    temp_bytes
FROM pg_stat_database 
WHERE datname = current_database();
EOF
}

# Function to get connection statistics
get_connections() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -t -A << EOF
SELECT 
    '$timestamp' as timestamp,
    COUNT(*) as total_connections,
    COUNT(CASE WHEN state = 'active' THEN 1 END) as active_connections,
    COUNT(CASE WHEN state = 'idle' THEN 1 END) as idle_connections,
    COUNT(CASE WHEN state = 'idle in transaction' THEN 1 END) as idle_in_transaction
FROM pg_stat_activity;
EOF
}

# Function to get slow queries
get_slow_queries() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -t -A << EOF
SELECT 
    '$timestamp' as timestamp,
    COUNT(*) as slow_query_count,
    COALESCE(AVG(EXTRACT(EPOCH FROM (now() - query_start))), 0) as avg_query_duration
FROM pg_stat_activity 
WHERE state = 'active' 
AND query_start < now() - interval '5 seconds'
AND query NOT LIKE '%pg_stat_activity%';
EOF
}

# Initialize log files
echo "timestamp,datname,cache_hit_ratio,tup_returned,tup_fetched,tup_inserted,tup_updated,tup_deleted,conflicts,temp_files,temp_bytes" > "${LOG_FILE}.db_stats"
echo "timestamp,total_connections,active_connections,idle_connections,idle_in_transaction" > "${LOG_FILE}.connections"
echo "timestamp,slow_query_count,avg_query_duration" > "${LOG_FILE}.slow_queries"

# Main monitoring loop
END_TIME=$(($(date +%s) + DURATION))
ITERATION=0

while [ $(date +%s) -lt $END_TIME ]; do
    ITERATION=$((ITERATION + 1))
    CURRENT_TIME=$(date +'%H:%M:%S')
    
    echo -n -e "\r${BLUE}[$CURRENT_TIME]${NC} Collecting metrics... (iteration $ITERATION)"
    
    # Collect metrics
    get_metrics >> "${LOG_FILE}.db_stats" 2>/dev/null
    get_connections >> "${LOG_FILE}.connections" 2>/dev/null
    get_slow_queries >> "${LOG_FILE}.slow_queries" 2>/dev/null
    
    # Display current status
    CACHE_HIT=$(tail -1 "${LOG_FILE}.db_stats" 2>/dev/null | cut -d',' -f3)
    ACTIVE_CONN=$(tail -1 "${LOG_FILE}.connections" 2>/dev/null | cut -d',' -f3)
    SLOW_QUERIES=$(tail -1 "${LOG_FILE}.slow_queries" 2>/dev/null | cut -d',' -f2)
    
    if [ ! -z "$CACHE_HIT" ] && [ ! -z "$ACTIVE_CONN" ]; then
        echo -n -e "\r${BLUE}[$CURRENT_TIME]${NC} Cache Hit: ${GREEN}${CACHE_HIT}%${NC} | Active Conn: ${GREEN}${ACTIVE_CONN}${NC} | Slow Queries: ${YELLOW}${SLOW_QUERIES:-0}${NC}"
    fi
    
    sleep $INTERVAL
done

echo
echo
echo -e "${GREEN}Monitoring completed!${NC}"
echo "Log files created:"
echo "  - Database stats: ${LOG_FILE}.db_stats"
echo "  - Connections: ${LOG_FILE}.connections"
echo "  - Slow queries: ${LOG_FILE}.slow_queries"

# Generate summary
echo
echo "=== MONITORING SUMMARY ==="
echo "Duration: $(($DURATION/60)) minutes"
echo "Intervals collected: $ITERATION"

# Cache hit ratio summary
if [ -f "${LOG_FILE}.db_stats" ]; then
    AVG_CACHE=$(awk -F',' 'NR>1 && $3!="" {sum+=$3; count++} END {if(count>0) printf "%.2f", sum/count}' "${LOG_FILE}.db_stats")
    MIN_CACHE=$(awk -F',' 'NR>1 && $3!="" {if(min=="" || $3<min) min=$3} END {print min}' "${LOG_FILE}.db_stats")
    MAX_CACHE=$(awk -F',' 'NR>1 && $3!="" {if(max=="" || $3>max) max=$3} END {print max}' "${LOG_FILE}.db_stats")
    
    echo "Cache Hit Ratio - Avg: ${AVG_CACHE}% | Min: ${MIN_CACHE}% | Max: ${MAX_CACHE}%"
fi

# Connection summary
if [ -f "${LOG_FILE}.connections" ]; then
    AVG_ACTIVE=$(awk -F',' 'NR>1 && $3!="" {sum+=$3; count++} END {if(count>0) printf "%.0f", sum/count}' "${LOG_FILE}.connections")
    MAX_ACTIVE=$(awk -F',' 'NR>1 && $3!="" {if(max=="" || $3>max) max=$3} END {print max}' "${LOG_FILE}.connections")
    
    echo "Active Connections - Avg: ${AVG_ACTIVE} | Peak: ${MAX_ACTIVE}"
fi

echo
echo "Use the following commands to analyze the data:"
echo "  # View database performance trends"
echo "  cat '${LOG_FILE}.db_stats' | column -t -s','"
echo
echo "  # View connection patterns"  
echo "  cat '${LOG_FILE}.connections' | column -t -s','"
echo
echo "  # View slow query trends"
echo "  cat '${LOG_FILE}.slow_queries' | column -t -s','"
