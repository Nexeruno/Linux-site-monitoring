#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/root/training/site"

require_root(){
 if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: Run this script as root or with sudo"
  exit 1
 fi
}

check_project_dir(){
 if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: Project directory does not exist: $PROJECT_DIR"
  exit 1
 fi

 if [[ ! -f "$PROJECT_DIR/run-sites.sh" ]]; then
  echo "ERROR: run-sites.sh not found in: $PROJECT_DIR"
  exit 1
 fi
}

main(){

 require_root
 check_project_dir

 echo "OK: install checks passed."
}

main "$@"
