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

create_config_env(){
 if [[ -f "$PROJECT_DIR/config.env" ]]; then
  echo "OK: config.env already exists."
  return 0
 fi

 if [[ ! -f "$PROJECT_DIR/config.env.example" ]]; then
  echo "WARN: config.env.example not found, skipping config.env creation."
  return 0
 fi

 cp "$PROJECT_DIR/config.env.example" "$PROJECT_DIR/config.env"
 chmod 600 "$PROJECT_DIR/config.env"

 echo "OK: config.env created from config.env.example."
}

create_runtime_dirs(){
 mkdir -p "$PROJECT_DIR/logs"
 mkdir -p "$PROJECT_DIR/state"
 
 chmod 755 "$PROJECT_DIR/logs"
 chmod 755 "$PROJECT_DIR/state"

 echo "OK: runtime directories are ready."
}

main(){

 require_root
 check_project_dir
 create_config_env
 create_runtime_dirs
 echo "OK: install checks passed."
}

main "$@"
