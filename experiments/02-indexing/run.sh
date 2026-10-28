#!/bin/bash
# Experiment 02 - Indexing: create the test index, then run the query tests.
# Runs against the database initialised by experiment 01.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"
require_cmd psql

run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/index-creation.sql"
run_psql "$PRIMARY_HOST" "$BASECASE_DB" -f "$HERE/performance-tests.sql"
