#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/site.log"
CSV_FILE="$LOG_DIR/site.csv"
SLOW_LIMIT="2"
VERSION="1.0.0"

version(){
 if [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
  echo "site.sh version $VERSION"
  exit 0
 fi
}


show_help(){
 echo "Pouziti:"
 echo "  ./site.sh <URL> [SLOW_LIMIT]"
 echo
 echo "Popis:"
 echo "  Zkontroluje dostupnost webu, HTTP kod, curl exit code,"
 echo "  response time, redirect URL a ulozi vysledek do logu."
 echo
 echo "Argumenty:"
 echo "  URL    Povinna URL, musi zacinat http:// nebo https://"
 echo "  SLOW_LIMIT  Volitelny limit v sekundach pro pomalou odpoved"
 echo
 echo "Priklady:"
 echo "  ./site.sh https://seznam.cz"
 echo "  ./site.sh https://seznam.cz 1"
 echo "  ./site.sh https://seznam.cz 0.5"
 echo
 echo "Napoveda:"
 echo "  ./site.sh -h"
 echo "  ./site.sh --help"
 echo
 echo "  ./site.sh -v"
 echo "  ./site.sh --version"
}

help(){
 if [ "$1" == "-h" ] || [ "$1" ==  "--help" ]; then
  show_help
  exit 0
 fi
}


check_help(){
 if [ -z "$1" ]; then
  show_help
  exit 1
 fi
}

check_url_format(){
 local URL="$1"

 if [[ "$URL" != http://* && "$URL" != https://* ]]; then
  echo "ERROR: URL musi zacinat http:// nebo https://"
  echo "Priklad: ./site.sh https://google.cz"
  return 1
 fi
 return 0
}

is_slow_response(){
 local RESPONSE_TIME="$1"
 awk -v time="$RESPONSE_TIME" -v limit="$SLOW_LIMIT" 'BEGIN { exit !(time > limit) }'
}

check_slow_limit_format(){
 local LIMIT="$1"
 
 if [[ ! "$LIMIT" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "ERROR: slow limit musi byt cislo"
  echo "Priklad: ./site.sh https://google.cz 3"
  echo "Priklad: ./site.sh https://google.cz 0.5"
  return 1
 fi
 return 0
}

check_dependencies(){
 if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: chybi prikaz curl"
  return 1
 fi

 if ! command -v awk >/dev/null 2>&1; then
  echo "ERROR: chybi prikaz awk"
  return 1
 fi

 if ! command -v tee >/dev/null 2>&1; then
  echo "ERROR: chybi prikaz tee"
  return 1
 fi

 return 0
}

check_args_count(){
 if [ "$#" -gt 2 ]; then
  echo "ERROR: moc argumentu"
  echo "Pouziti: ./site.sh <URL> [SLOW_LIMIT]"
  return 1
 fi
 return 0
}


folder(){
 if [ ! -d "$LOG_DIR" ]; then
  echo "Slozka $LOG_DIR neexistuje, vytvarim..."

  if ! mkdir -p "$LOG_DIR"; then
   echo "ERROR: slozku $LOG_DIR se nepodarilo vytvorit"
   return 1
  fi

  echo "Slozka $LOG_DIR byla vytvorena"
 fi

 return 0
}

result(){
 local URL="$3"
 local HTTP_CODE="$2"
 local CURL_EXIT="$1"
 local RESULT="$4"
 local STATUS="$5"
 local RESPONSE_TIME="$6"
 local REDIRECT_URL="$7"

 {
  echo "__________________________________"
  echo "TIME: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "URL: $URL"
  echo "HTTP_CODE: $HTTP_CODE"
  echo "CURL_EXIT: $CURL_EXIT"
  echo "SITE_EXIT: $RESULT"
  echo "STATUS: $STATUS"
  echo "RESPONSE_TIME: ${RESPONSE_TIME}"
  echo "SLOW_LIMIT: ${SLOW_LIMIT}s"
  echo "REDIRECT_URL: $REDIRECT_URL"
  echo "__________________________________"
 } | tee -a "$LOG_FILE"

 if [ ! -f "$CSV_FILE" ]; then
  echo "time;url;http_code;curl_exit;site_exit;status;response_time;slow_limit;redirect_url" > "$CSV_FILE"
 fi

echo "$(date '+%Y-%m-%d %H:%M:%S');$URL;$HTTP_CODE;$CURL_EXIT;$RESULT;$STATUS;$RESPONSE_TIME;$SLOW_TIME;$REDIRECT_URL" >> "$CSV_FILE"

}

check_web() {
  local CURL_EXIT="$1"
  local HTTP_CODE="$2"
  local URL="$3"
  local RESPONSE_TIME="$4"
  local REDIRECT_URL="$5"
  local RESULT=1
  local STATUS="UNKNOWN"

  if [ "$CURL_EXIT" -eq 0 ]; then
    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 300 ]; then
      echo "OK: web odpovedel uspesnym kodem $HTTP_CODE"
      RESULT=0
      STATUS="OK"

    elif [ "$HTTP_CODE" -ge 300 ] && [ "$HTTP_CODE" -lt 400 ]; then
      echo "REDIRECT: web presmerovan kodem $HTTP_CODE"
      RESULT=0
      STATUS="REDIRECT"

    elif [ "$HTTP_CODE" -eq 404 ]; then
      echo "NOT FOUND: stranka neexistuje"
      RESULT=1
      STATUS="NOT_FOUND"

    elif [ "$HTTP_CODE" -ge 400 ] && [ "$HTTP_CODE" -lt 500 ]; then
     echo "CLIENT ERROR: problem na strane pozadavku, kod $HTTP_CODE"
     RESULT=1
     STATUS="CLIENT_ERROR"

    elif [ "$HTTP_CODE" -ge 500 ]; then
      echo "SERVER ERROR: server ma problem, kod $HTTP_CODE"
      RESULT=1
      STATUS="SERVER_ERROR"

    else
      echo "HTTP INFO: web odpovedel kodem $HTTP_CODE"
      RESULT=1
      STATUS="HTTP_UNKNOWN"
    fi

  elif [ "$CURL_EXIT" -eq 6 ]; then
    echo "DNS ERROR: domena nejde prelozit"
    RESULT=1
    STATUS="DNS_ERROR"

  elif [ "$CURL_EXIT" -eq 7 ]; then
    echo "CONNECTION ERROR: server nebo port je nedostupny"
    RESULT=1
    STATUS="CONNECTION_ERROR"

  elif [ "$CURL_EXIT" -eq 28 ]; then
    echo "TIMEOUT: server neodpovedel vcas"
    RESULT=1
    STATUS="TIMEOUT"

  elif [ "$CURL_EXIT" -eq 35 ]; then
    echo "SSL CONNECT ERROR: problem pri SSL spojeni"
    RESULT=1
    STATUS="SSL_CONNECT_ERROR"

  elif [ "$CURL_EXIT" -eq 52 ]; then
    echo "EMPTY REPLY: server nevratil zadnou odpoved"
    RESULT=1
    STATUS="EMPTY_REPLY"

  elif [ "$CURL_EXIT" -eq 56 ]; then
    echo "RECEIVE ERROR: problem pri prijmu dat ze serveru"
    RESULT=1
    STATUS="RECEIVE_ERROR"

  elif [ "$CURL_EXIT" -eq 60 ]; then
    echo "SSL CERT ERROR: problem s certifikatem nebo HTTPS"
    RESULT=1
    STATUS="SSL_CERT_ERROR"

  else
    echo "NETWORK ERROR: curl chyba $CURL_EXIT"
    RESULT=1
    STATUS="NETWORK_ERROR"
  fi

  if [ "$RESULT" -eq 0 ]; then
   if is_slow_response "$RESPONSE_TIME"; then
    echo "SLOW RESPONSE: web odpovedel pomalu"
    RESULT=1
    STATUS="SLOW_RESPONSE"
   fi
  fi

  result "$CURL_EXIT" "$HTTP_CODE" "$URL" "$RESULT" "$STATUS" "$RESPONSE_TIME" "$REDIRECT_URL"
  return "$RESULT"
}


main() {
 local URL="$1"
 local CUSTOM_SLOW_LIMIT="$2"

 help "$1"

 version "$1"

 if ! check_args_count "$@"; then
  exit 1
 fi

 check_help "$URL"

 if ! check_dependencies; then
  exit 1
 fi

 if ! check_url_format "$URL"; then
  exit 1
 fi

 if [ -n "$CUSTOM_SLOW_LIMIT" ]; then
  if ! check_slow_limit_format "$CUSTOM_SLOW_LIMIT"; then
   exit 1
  fi

  SLOW_LIMIT="$CUSTOM_SLOW_LIMIT"
 fi

 if ! folder; then
  exit 1
 fi

 CURL_OUTPUT=$(curl -s -o /dev/null -w "%{http_code} %{time_total} %{redirect_url}" --connect-timeout 5 --max-time 10 "$URL")
 CURL_EXIT=$?

 HTTP_CODE=$(echo "$CURL_OUTPUT" | awk '{print $1}')
 RESPONSE_TIME=$(echo "$CURL_OUTPUT" | awk '{print $2}')
 REDIRECT_URL=$(echo "$CURL_OUTPUT" | awk '{print $3}')

 check_web "$CURL_EXIT" "$HTTP_CODE" "$URL" "$RESPONSE_TIME" "$REDIRECT_URL"
}

main "$@"
