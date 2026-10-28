#!/bin/bash
# Offline sanity checks for the repository (no database required):
#   1. every shell script parses
#   2. every experiment has README.md, results.md and run.sh
#   3. every experiment's run.sh completes in DRY_RUN mode

source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

STATUS=0

log "Checking shell script syntax..."
while IFS= read -r script; do
    if ! bash -n "$script"; then
        error "Syntax error: ${script#$REPO_ROOT/}"
        STATUS=1
    fi
done < <(find "$REPO_ROOT/scripts" "$REPO_ROOT/experiments" -name '*.sh' | sort)

log "Checking experiment layout..."
for dir in "$REPO_ROOT"/experiments/*/; do
    name=$(basename "$dir")
    for required in README.md results.md run.sh; do
        if [ ! -f "$dir/$required" ]; then
            error "$name is missing $required"
            STATUS=1
        fi
    done
done

log "Dry-running every experiment..."
for runner in "$REPO_ROOT"/experiments/*/run.sh; do
    if ! DRY_RUN=1 bash "$runner" > /dev/null; then
        error "Dry run failed: ${runner#$REPO_ROOT/}"
        STATUS=1
    fi
done

if [ $STATUS -eq 0 ]; then
    success "All checks passed"
fi
exit $STATUS
