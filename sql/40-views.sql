CREATE OR REPLACE VIEW firewall.mirai_events AS
SELECT *
FROM firewall.events
WHERE mirai_signature;

CREATE OR REPLACE VIEW firewall.telnet_scans AS
SELECT *
FROM firewall.events
WHERE net_dst_port IN (23, 2323);

