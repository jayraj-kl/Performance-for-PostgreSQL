#!/bin/bash
# Experiment 04 - Connection Pooling: direct endpoint vs. RDS Proxy endpoint.
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$HERE/benchmark-direct.sh"
bash "$HERE/benchmark-proxy.sh"
