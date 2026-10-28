#!/bin/bash
# Experiment 03 - Query Optimization: enable pg_stat_statements, then analyse.
# Runs against the database initialised by experiment 01.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"
require_cmd psql

run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/setup.sql"
run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/slow-query-analysis.sql"
run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/explain-analysis.sql"
run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/performance-monitoring.sql"
