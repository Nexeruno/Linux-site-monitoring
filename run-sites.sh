#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
ALERT_FILE="$LOG_DIR/alerts.log"
URL_FILE="$SCRIPT_DIR/urls.txt"
STATE_DIR="$SCRIPT_DIR/state"
STATUS_FILE="$LOG_DIR/status.txt"
MONITOR_SOFT_FAIL="${MONITOR_SOFT_FAIL:-0}"

mkdir -p "$LOG_DIR"
mkdir -p "$STATE_DIR"

echo "========================"
echo "Run started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "======================="

CHECKED=0
SKIPPED=0
OK_COUNT=0
FAIL_COUNT=0

echo "Last run: $(date '+%Y-%m-%d %H:%M:%S')" > "$STATUS_FILE"
echo >> "$STATUS_FILE"

if [ ! -f "$URL_FILE" ]; then
  echo "ERROR: soubor $URL_FILE neexistuje"
  exit 1
fi

while read -r URL; do
 URL=$(echo "$URL" | xargs)

 if [ -z "$URL" ]; then
  continue
 fi

 if [[ "$URL" == \#* ]]; then
  continue
 fi

 if [[ "$URL" != http://* && "$URL" != https://* ]]; then
  echo "SKIP: Invalid URL format: $URL"
  SKIPPED=$((SKIPPED + 1))
  continue
 fi

CHECKED=$((CHECKED + 1))

echo "Kontroluji: $URL"

STATE_FILE="$STATE_DIR/$(echo -n "$URL" | sha256sum | awk '{print $1}').state"
PREVIOUS_STATE="UNKNOWN"

if [ -f  "$STATE_FILE" ]; then
 PREVIOUS_STATE=$(cat "$STATE_FILE")
fi

if "$SCRIPT_DIR/site.sh" "$URL"; then
 OK_COUNT=$((OK_COUNT + 1))
 echo "OK     $URL" >> "$STATUS_FILE"

 if [ "$PREVIOUS_STATE" = "FAILED" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') | RECOVERED | $URL" >> "$ALERT_FILE"
 fi

 echo "OK" > "$STATE_FILE"
else
 FAIL_COUNT=$((FAIL_COUNT + 1))
 echo "FAILED $URL" >> "$STATUS_FILE"

 if [ "$PREVIOUS_STATE" != "FAILED" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') | DOWN | $URL" >> "$ALERT_FILE"
 fi

echo "FAILED" > "$STATE_FILE"
fi

echo

done < "$URL_FILE"

{
  echo
  echo "Summary:"
  echo "Checked: $CHECKED"
  echo "OK: $OK_COUNT"
  echo "FAILED: $FAIL_COUNT"
  echo "Skipped invalid: $SKIPPED"
} >> "$STATUS_FILE"

echo
echo "=========Sumary=============="
echo "Run finished: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Checked: $CHECKED"
echo "OK: $OK_COUNT"
echo "FAILED: $FAIL_COUNT"
echo "Skipped invalid: $SKIPPED"
echo "============================="



if [ "$CHECKED" -eq 0 ]; then
 echo "ERROR: No valid URLs found in urls.txt"
 exit 1
fi

if [ "$FAIL_COUNT" -gt 0 ]; then
 if [ "$MONITOR_SOFT_FAIL" = "1" ]; then
  echo "WARNING: Some sites failed, but Monitor_SOFT_FAIL=1, exiting with code 0"
  exit 0
 fi

 exit 1
fi

exit 0
