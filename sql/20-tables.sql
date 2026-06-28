CREATE TABLE IF NOT EXISTS firewall.event_staging (
    line text NOT NULL
);

CREATE TABLE IF NOT EXISTS firewall.events (
    id bigserial PRIMARY KEY,

    event_type text NOT NULL,
    parser_version integer NOT NULL,

    reported_at timestamptz NOT NULL,
    received_at timestamptz NOT NULL,
    reported_tz text,
    received_tz text,

    observer_host text,
    observer_ip inet,
    observer_name text,

    fw_rule_key text,
    fw_rule_id bigint,
    fw_zone text,
    fw_action text,

    net_iface text,
    net_ip_family text,
    net_src_ip inet,
    net_dst_ip inet,
    net_protocol text,
    net_src_port integer,
    net_dst_port integer,
    net_ttl integer,
    net_seq bigint,
    net_window integer,

    net_flag_syn boolean,
    net_flag_ack boolean,
    net_flag_fin boolean,
    net_flag_rst boolean,
    net_flag_psh boolean,
    net_flag_urg boolean,

    raw_message text,

    inserted_at timestamptz NOT NULL DEFAULT now(),

    mirai_signature boolean GENERATED ALWAYS AS (
        net_flag_syn
        AND family(net_dst_ip) = 4
        AND net_seq = firewall.ipv4_to_bigint(net_dst_ip)
    ) STORED,

    CONSTRAINT events_event_type_check
        CHECK (event_type = 'firewall'),

    CONSTRAINT events_fw_action_check
        CHECK (fw_action IN ('drop', 'accept', 'reject', 'other')),

    CONSTRAINT events_net_protocol_check
        CHECK (net_protocol IN ('tcp', 'udp', 'icmp', 'icmpv6', 'other'))
);

CREATE TABLE IF NOT EXISTS firewall.imported_files (
    id bigserial PRIMARY KEY,
    source_host text NOT NULL,
    source_path text NOT NULL,
    source_size bigint,
    source_sha256 text NOT NULL,
    imported_at timestamptz NOT NULL DEFAULT now(),
    row_count bigint NOT NULL,

    UNIQUE (source_host, source_path, source_sha256)
);
