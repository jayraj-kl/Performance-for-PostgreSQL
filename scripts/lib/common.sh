#!/bin/bash
# Shared helpers for all experiment and utility scripts.
#
# Usage (from any script in the repo):
#   source "$(dirname "${BASH_SOURCE[0]}")/<relative path>/scripts/lib/common.sh"
#
# Provides:
#   REPO_ROOT                 absolute path of the repository
#   config variables          loaded from config/ (see config/defaults.env)
#   log/success/warning/error coloured logging
#   banner TITLE TARGET       standard script header
#   run_pgbench HOST DB ARGS  pgbench against HOST/DB with shared port and user
#   run_psql HOST DB ARGS     psql against HOST/DB with shared port and user
#
# Set DRY_RUN=1 to print the pgbench/psql commands instead of executing them.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export REPO_ROOT

# Colors for output (disabled when stdout is not a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

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

# Export KEY=VALUE pairs from a file without overriding variables that are
# already set, so values loaded earlier (or from the shell) take precedence.
_load_env_file() {
    local file=$1 line key value
    [ -f "$file" ] || return 0
    while IFS= read -r line || [ -n "$line" ]; do
        line=${line%$'\r'}
        case $line in
            '' | '#'*) continue ;;
        esac
        key=${line%%=*}
        value=${line#*=}
        value=${value%\"}
        value=${value#\"}
        if [ -z "${!key+x}" ]; then
            export "$key=$value"
        fi
    done < "$file"
}

# Precedence: shell environment > config/local.env > config/defaults.env
_load_env_file "$REPO_ROOT/config/local.env"
_load_env_file "$REPO_ROOT/config/defaults.env"

banner() {
    echo "$1"
    echo "Target: $2"
    echo "============================================"
}

_exec() {
    if [ "${DRY_RUN:-0}" = "1" ]; then
        printf '[dry-run]'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

require_cmd() {
    [ "${DRY_RUN:-0}" = "1" ] && return 0
    local cmd
    for cmd in "$@"; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            error "Required command not found: $cmd"
            exit 1
        fi
    done
}

run_pgbench() {
    local host=$1 db=$2
    shift 2
    _exec pgbench "$@" -h "$host" -p "$PGPORT" -U "$PGUSER" -d "$db"
}

run_psql() {
    local host=$1 db=$2
    shift 2
    _exec psql -h "$host" -p "$PGPORT" -U "$PGUSER" -d "$db" "$@"
}
