SELECT
    net_src_port,
    net_dst_port,
    count(*) AS scans
FROM firewall.events
WHERE net_src_ip <<= :'subnet'
GROUP BY
    net_src_port,
    net_dst_port
ORDER BY
    scans DESC;
