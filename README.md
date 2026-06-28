# Project remore log analysis tool

## Background
After spending way too much time writing scripts to pull firewall logs over 
and analyzing them one-by-one, I got tired and sat down to have the firewall/router
send dropped connects to a remote log server, where the log is transformed to JSON 
and stored in a PostgreSQL database.

## Parts:

### Rsyslog
The rsyslog-remotelogexample.conf is a template for rsyslog 8.2312 (Standard version in Ubuntu 24.10)
that handles some of the quirks of that version. If you use an older/newer version, expect 
some friction...

A raw event from a router might look something like this:
<13>Jun 19 23:46:33 <router name> <router name> [<fw-rule-name>] DESCR="[<description>]Block All Traffic" IN=<eth if> OUT= MAC=<MAC> SRC=<SOURCE IP> DST=<DST IP> LEN=XX TOS=YY PREC=0x00 TTL=<TTL> ID=<ID> PROTO=TCP SPT=51765 DPT=9332 SEQ=<SEQ> ACK=0 WINDOW=<WIN> SYN URGP=0 MARK=<MARK>

The ruleset in the file will create a JSON object containing all the data found in the log entry.
As this will most certainly differ between routers, you will need to tweak the rsyslog config.

### JQ
In the jq folder you will find a jq filter that extracts incoming JSON log files
record by record and transform them to a format suitable for the PosgreSQL db.
The scripts in the bin folder assumes the jqfilter.jq file is in the project root, so 
there's a copy of it there at the moment.

### SQL
The sql folder contains files needed to set up a PostgreSQL database that holds log data. 
You will need to set up the user/password yourself.

### Binaries/scripts
The bin folder contains scripts that can be used to pull JSON data from a logserver into the database
staging table, and then into the target table. The 2-step process is to catch any errors before importing live data.
These scripts will assume you've set up environment variables in a config.env file in the project
root. See config.env.example for how that is done.

The scripts to transfer data are set up to transfer all data from __yesterday__ to ensure all data are added properly.
It's possible to have data added as they arrive, and this project will probably head in that direction later on.

