#!/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

check_bash_syntax(){
    echo "Checking Bash syntax..."

    bash -n "$PROJECT_DIR/site.sh"
    bash -n "$PROJECT_DIR/run-sites.sh"
    bash -n "$PROJECT_DIR/install.sh"
    bash -n "$PROJECT_DIR/uninstall.sh"
    bash -n "$PROJECT_DIR/health-check.sh"

    echo "OK: Bash syntax check passed."
}

check_required_files(){
    echo "Checking required files..."

    local files=(
        urls.txt
        config.env
        "urls.txt"
        "config.env.example"
        "run-sites.sh"
        "site.sh"
        "install.sh"
        "uninstall.sh"
        "health-check.sh"
        "systemd/site-monitor.service"
        "systemd/site-monitor.timer"
    )

    for file in "${files[@]}"; do
     if [[ -f "$PROJECT_DIR/$file" ]]; then
      echo "OK: $file exists"
     else
      echo "ERROR: $file is missing"
      exit 1
     fi
     done
}

check_required_dirs(){
    echo "Checking required directories..."

    local dirs=(
        logs
        state
        logrotate
        systemd
    )

    for dir in "${dirs[@]}"; do
     if [[ -d "$PROJECT_DIR/$dir" ]]; then
     echo "OK: $dir exists"
    else
     echo "ERROR: $dir is missing"
     exit 1
    fi
    done 
}

main(){
    echo "Runing test project checks..."
    echo

    check_bash_syntax
    echo

    check_required_files
    echo

    check_required_dirs
    echo

    echo "All checks completed."
}

main "$@"