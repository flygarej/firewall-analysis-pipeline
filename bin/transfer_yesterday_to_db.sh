#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
[[ -f "$BASE_DIR/config.env" ]] && source "$BASE_DIR/config.env"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-logdb}"
DB_USER="${DB_USER:-loguser}"
REMOTE_HOST="${REMOTE_HOST:-logserver}"
REMOTE_FILE="${REMOTE_FILE:-/var/log/remotelogs/firewall.log.1}"
ssh $REMOTE_HOST "cat $REMOTE_FILE" \
    | jq -c -f jqfilter.jq \
    | psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
      -c "COPY firewall.event_staging(line)
      FROM STDIN
      WITH (FORMAT csv, DELIMITER E'\x02', QUOTE E'\x01', ESCAPE E'\x01');"
