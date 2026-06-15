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

check_required_commands(){
 local missing=0

 for cmd in curl flock systemctl; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
   echo "ERROR: Required command not found: $cmd"
   missing=1
  fi
 done

 if [[ "$missing" -ne 0 ]]; then
  echo "ERROR: Install missing required commands before continuing"
  exit 1
 fi

 echo "OK: required commands are available."
}

install_systemd_files(){
 local service_file="$PROJECT_DIR/systemd/site-monitor.service"
 local timer_file="$PROJECT_DIR/systemd/site-monitor.timer"

 if [[ ! -f "$service_file" ]]; then
  echo "ERROR: Missing systemd service file: $service_file"
  exit 1
 fi

 if [[ ! -f "$timer_file" ]]; then
  echo "ERROR: Missing systemd timer file: $timer_file"
  exit 1
 fi

 cp "$service_file" /etc/systemd/system/site-monitor.service
 cp "$timer_file" /etc/systemd/system/site-monitor.timer
 
 systemctl daemon-reload
 
 echo "OK: systemd service and timer installed."
}

enable_timer(){
 systemctl enable --now site-monitor.timer
 
 echo "OK: site-monitor.timer enabled and started."
}


main(){

 require_root
 check_project_dir
 create_config_env
 create_runtime_dirs
 check_required_commands
 install_systemd_files
 enable_timer

 echo "OK: install checks passed."
}

main "$@"
