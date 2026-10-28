#!/bin/bash
# Experiment 01 - Base Case: initialise, benchmark, then snapshot statistics.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"

bash "$HERE/benchmark.sh"
run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/performance-monitoring.sql"
