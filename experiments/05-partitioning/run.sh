#!/bin/bash
# Experiment 05 - Partitioning: create tables, load data, run comparisons.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"
require_cmd psql

run_psql "$PARTITION_HOST" "$PARTITION_DB" -f "$HERE/table-creation.sql"
run_psql "$PARTITION_HOST" "$PARTITION_DB" -f "$HERE/data-generation.sql"
run_psql "$PARTITION_HOST" "$PARTITION_DB" -f "$HERE/performance-tests.sql"
