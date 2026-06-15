#!/usr/bin/env bash
set -euo pipefail

TIMER_NAME="site-monitor.timer"
SERVICE_NAME="site-monitor.service"
SYSTEMD_DIR="/etc/systemd/system"

require_root(){
 if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: Run this script as root or with sudo."
  exit 1
 fi
}

stop_and_disable_timer(){
 if systemctl list-unit-files "$TIMER_NAME" >/dev/null 2>&1; then
   systemctl disable --now "$TIMER_NAME" >/dev/null 2>&1 || true
   echo "OK: $TIMER_NAME stopped and disabled."
 else
   echo "OK: $TIMER_NAME is not installed, skipping stop."
 fi
}

remove_systemd_files(){
 rm -f "$SYSTEMD_DIR/$TIMER_NAME"
 rm -f "$SYSTEMD_DIR/$SERVICE_NAME"

 systemctl daemon-reload

 echo "OK: systemd files removed."
}

main(){
 require_root
 stop_and_disable_timer
 remove_systemd_files

 echo "OK: uninstall completed successfully."
 echo "INFO: logs/, state/ and config.env were kept."
}

main "$@"
