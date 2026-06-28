CREATE OR REPLACE FUNCTION firewall.ipv4_to_bigint(ip inet)
RETURNS bigint
LANGUAGE sql
IMMUTABLE
AS $$
SELECT
      split_part(host(ip), '.', 1)::bigint * 16777216
    + split_part(host(ip), '.', 2)::bigint * 65536
    + split_part(host(ip), '.', 3)::bigint * 256
    + split_part(host(ip), '.', 4)::bigint;
$$;

CREATE OR REPLACE FUNCTION firewall.insert_event(j jsonb)
RETURNS bigint
LANGUAGE sql
AS $$
INSERT INTO firewall.events (
    event_type, parser_version,
    reported_at, received_at,
    reported_tz, received_tz,
    observer_host, observer_ip, observer_name,
    fw_rule_key, fw_rule_id, fw_zone, fw_action,
    net_iface, net_ip_family,
    net_src_ip, net_dst_ip, net_protocol,
    net_src_port, net_dst_port,
    net_ttl, net_seq, net_window,
    net_flag_syn, net_flag_ack, net_flag_fin,
    net_flag_rst, net_flag_psh, net_flag_urg,
    raw_message
)
SELECT
    j->>'event_type',
    (j->>'parser_version')::integer,
    (j->>'reported_at')::timestamptz,
    (j->>'received_at')::timestamptz,
    j->>'reported_tz',
    j->>'received_tz',
    j->>'observer_host',
    (j->>'observer_ip')::inet,
    j->>'observer_name',
    j->>'fw_rule_key',
    (j->>'fw_rule_id')::bigint,
    j->>'fw_zone',
    j->>'fw_action',
    j->>'net_iface',
    j->>'net_ip_family',
    (j->>'net_src_ip')::inet,
    (j->>'net_dst_ip')::inet,
    j->>'net_protocol',
    (j->>'net_src_port')::integer,
    (j->>'net_dst_port')::integer,
    (j->>'net_ttl')::integer,
    (j->>'net_seq')::bigint,
    (j->>'net_window')::integer,
    ((j->>'net_flag_syn')::integer)::boolean,
    ((j->>'net_flag_ack')::integer)::boolean,
    ((j->>'net_flag_fin')::integer)::boolean,
    ((j->>'net_flag_rst')::integer)::boolean,
    ((j->>'net_flag_psh')::integer)::boolean,
    ((j->>'net_flag_urg')::integer)::boolean,
    j->>'raw_message'
RETURNING id;
$$;
