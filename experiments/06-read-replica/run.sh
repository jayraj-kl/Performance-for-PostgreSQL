#!/bin/bash
# Experiment 06 - Read Replica: initialise primary, write test on primary,
# read test on replica, then measure replication lag on the replica.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../scripts/lib/common.sh"
require_cmd psql

bash "$HERE/setup.sh"
bash "$HERE/benchmark-primary.sh"
bash "$HERE/benchmark-replica.sh"
run_psql "$REPLICA_HOST" "$REPLICA_DB" -f "$HERE/replication-monitoring.sql"
