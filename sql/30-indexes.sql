CREATE INDEX IF NOT EXISTS events_reported_at_idx
ON firewall.events (reported_at);

CREATE INDEX IF NOT EXISTS events_src_ip_idx
ON firewall.events (net_src_ip);

CREATE INDEX IF NOT EXISTS events_src_ip_time_idx
ON firewall.events (net_src_ip, reported_at);

CREATE INDEX IF NOT EXISTS events_dst_port_idx
ON firewall.events (net_dst_port);

CREATE INDEX IF NOT EXISTS events_dst_port_time_idx
ON firewall.events (net_dst_port, reported_at);

CREATE INDEX IF NOT EXISTS events_action_time_idx
ON firewall.events (fw_action, reported_at DESC);

CREATE INDEX IF NOT EXISTS events_mirai_signature_time_idx
ON firewall.events (reported_at)
WHERE mirai_signature;

