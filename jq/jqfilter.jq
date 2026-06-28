{
  # text
  event_type: ."$!".event.kind,
  # integer
  parser_version: (."$!".event.parser_version | tonumber?),
  # timestamptz
  reported_at: .timereported,
  # text
  reported_tz: ."$!".event.reported_tz,
  #timestamptz
  received_at: .timegenerated,
  # text
  received_tz: ."$!".event.received_tz,
  # text
  observer_host: .hostname,
  # inet
  observer_ip: ."fromhost-ip",
  # text
  observer_name: ."$!".observer.name,
  # text
  fw_rule_key: ."$!".firewall.rule_key,
  # bigint
  fw_rule_id: ."$!".firewall.rule_id,
  # text
  fw_zone: ."$!".firewall.zone,
  # text
  fw_action: ."$!".firewall.action,
  # text
  net_iface: ."$!".network.iface,
  # text
  net_ip_family: ."$!".network.ip_family,
  # inet
  net_src_ip: (."$!".network.src_ip),
  # inet
  net_dst_ip: (."$!".network.dst_ip),
  # text
  net_protocol: (."$!".network.protocol | ascii_downcase?),
  # integer
  net_src_port: (."$!".network.src_port | tonumber?),
  # integer
  net_dst_port: (."$!".network.dst_port | tonumber?),
  # integer
  net_ttl: (."$!".network.ttl | tonumber?),
  # bigint
  net_seq: (."$!".network.seq | tonumber?),
  # integer
  net_window: (."$!".network.window | tonumber?),
  # integer or boolean?
  net_flag_syn: (."$!".network.tcp_flags.syn | tonumber?),
  # integer or boolean?
  net_flag_ack: (."$!".network.tcp_flags.ack | tonumber?),
  # integer or boolean?
  net_flag_fin: (."$!".network.tcp_flags.fin | tonumber?),
  # integer or boolean?
  net_flag_rst: (."$!".network.tcp_flags.rst | tonumber?),
  # integer or boolean?
  net_flag_psh: (."$!".network.tcp_flags.psh | tonumber?),
  # integer or boolean?
  net_flag_urg: (."$!".network.tcp_flags.urg | tonumber?),
  # text
  raw_message: .rawmsg
}