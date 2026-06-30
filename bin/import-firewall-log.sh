#!/usr/bin/env bash
set -Eeuo pipefail

REMOTE_HOST="${REMOTE_HOST:-localhost}"
REMOTE_FILE="${1:-/var/log/remotelogs/firewall.log.1}"

DB_HOST="${DB_HOST:-helper}"
DB_PORT="${DB_PORT:-31432}"
DB_USER="${DB_USER:-loguser}"
DB_NAME="${DB_NAME:-logdb}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

JQ_FILTER="${JQ_FILTER:-$BASE_DIR/jqfilter.jq}"

tmp_raw="$(mktemp)"
tmp_json="$(mktemp)"
trap 'rm -f "$tmp_raw" "$tmp_json"' EXIT

psql_cmd=(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1)

echo "Fetching $REMOTE_HOST:$REMOTE_FILE"


case "$REMOTE_FILE" in
    *.gz)
        ssh "$REMOTE_HOST" "gzip -dc '$REMOTE_FILE'" > "$tmp_raw"
        ;;
    *)
        ssh "$REMOTE_HOST" "cat '$REMOTE_FILE'" > "$tmp_raw"
        ;;
esac

sha="$(sha256sum "$tmp_raw" | awk '{print $1}')"
size="$(wc -c < "$tmp_raw")"

already="$("${psql_cmd[@]}" -Atc "
SELECT EXISTS (
  SELECT 1
  FROM firewall.imported_files
  WHERE source_host = '$REMOTE_HOST'
    AND source_path = '$REMOTE_FILE'
    AND source_sha256 = '$sha'
);
")"

if [[ "$already" == "t" ]]; then
    echo "Already imported: $REMOTE_FILE"
    exit 0
fi

echo "Transforming with jq"
jq -c -f "$JQ_FILTER" < "$tmp_raw" > "$tmp_json"

rows="$(wc -l < "$tmp_json")"

if [[ "$rows" -eq 0 ]]; then
    echo "jq produced zero rows; aborting" >&2
    exit 1
fi

echo "Loading $rows rows into staging"

"${psql_cmd[@]}" -c "TRUNCATE firewall.event_staging;"

"${psql_cmd[@]}" -c "COPY firewall.event_staging(line)
FROM STDIN
WITH (FORMAT csv, DELIMITER E'\x02', QUOTE E'\x01', ESCAPE E'\x01');" < "$tmp_json"

echo "Inserting into firewall.events"

"${psql_cmd[@]}" <<SQL
BEGIN;

WITH inserted AS (
    SELECT firewall.insert_event(line::jsonb) AS id
    FROM firewall.event_staging
)
SELECT count(*) AS inserted_rows
FROM inserted;

TRUNCATE firewall.event_staging;

INSERT INTO firewall.imported_files (
    source_host,
    source_path,
    source_size,
    source_sha256,
    row_count
)
VALUES (
    '$REMOTE_HOST',
    '$REMOTE_FILE',
    $size,
    '$sha',
    $rows
);

COMMIT;
SQL

echo "Done: imported $rows rows from $REMOTE_FILE"
