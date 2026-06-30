SELECT
                net_src_ip,
                net_dst_ip,
                net_dst_port,
                net_seq,
                count(*) AS hits
            FROM firewall.events
            WHERE net_protocol = 'tcp'
              AND net_flag_syn = true
              AND family(net_dst_ip) = 4
              AND mirai_signature = true
            GROUP BY net_src_ip, net_dst_ip, net_dst_port, net_seq
            ORDER BY hits DESC
            LIMIT 50;
