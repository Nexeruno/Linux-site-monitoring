#!/bin/env bash
set -euo pipefail

PROJECT_DIR="/root/training/site"
TIMER_NAME="site-monitor.timer"
SERVICE_NAME="site-monitor.service"

check_file(){
    local file_path="$1"
    local file_name="$2"

    if [[ -f "$file_path" ]]; then
     echo "OK: $file_name exist"
    else
     echo "ERROR: $file_name is missing: $file_path"
     return 1
    fi
}

check_dir(){
    local dir_path="$1"
    local dir_name="$2"

    if [[ -d "$dir_path" ]]; then
     echo "OK: $dir_name directory exists"
    else
     echo "ERROR: $dir_name directory is missing: $dir_path"
     return 1
    fi
}

check_timer_enabled(){
    if systemctl is-enabled "$TIMER_NAME" >/dev/null 2>&1; then
     echo "OK: $TIMER_NAME is enabled"
    else
     echo "ERROR: $TIMER_NAME is not enabled"
     return 1
    fi
}

check_timer_active(){
    if systemctl is-active "$TIMER_NAME" >/dev/null 2>&1; then
     echo "OK: $TIMER_NAME is active"
    else
     echo "ERROR: $TIMER_NAME is not active"
     return 1
    fi
}

show_last_logs(){
    echo
    echo "INFO: Last 10 logs from $SERVICE_NAME:"
    journalctl -u "$SERVICE_NAME" -n 10 --no-pager || true
}

main(){
    echo "Running health-check"
    echo


    check_file "$PROJECT_DIR/config.env" "config.env"
    check_file "$PROJECT_DIR/urls.txt" "urls.txt"

    check_dir "$PROJECT_DIR/logs" "logs"
    check_dir "$PROJECT_DIR/state" "state"

    check_timer_enabled
    check_timer_active

    show_last_logs

    echo "Health-check completed."
}

main "$@"