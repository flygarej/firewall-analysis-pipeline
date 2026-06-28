#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
[[ -f "$BASE_DIR/config.env" ]] && source "$BASE_DIR/config.env"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-logdb}"
DB_USER="${DB_USER:-loguser}"

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "BEGIN;

SELECT count(*)
FROM (
    SELECT firewall.insert_event(line::jsonb)
    FROM firewall.event_staging
) x;

TRUNCATE firewall.event_staging;

COMMIT;"
