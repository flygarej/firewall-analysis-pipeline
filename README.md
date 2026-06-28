# Project remore log analysis tool

## Background
After spending way too much time writing scripts to pull firewall logs over 
and analyzing them one-by-one, I got tired and sat down to have the firewall/router
send dropped connects to a remote log server, where the log is transformed to JSON 
and stored in a PostgreSQL database.

## Parts:

### Rsyslog
In the Rsyslog folder is a config for rsyslog 8.2312 (Standard version in Ubuntu 24.10)
that handles some of the quirks of that version. If you use an older/newer version, expect 
some friction...

### JQ
In the jq folder you will find a jq filter that extracts incoming JSON log files
record by record and transform them to a format suitable for the PosgreSQL db.

### SQL
The sql folder contains several folders, but the main one is schema, with schema
creation files for the database

### Scripts
The scripts folder contains working scripts for ixtracting data from the log server, 
transforming using jq and inserting the "ready" JSON into a staging table in the db.
Other scripts then insert the data from the staging table into the final analysis table.

#### Fwlogs
The scripts/fwlogs is a ready-to-use folder for fetching and inserting log data into the
database.
