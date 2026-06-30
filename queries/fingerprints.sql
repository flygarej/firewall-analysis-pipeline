            SELECT
                net_src_ip,
                net_dst_port,
                net_ttl,
                net_window,
                net_flag_syn,
                net_flag_ack,
                net_flag_rst,
                count(*) AS hits
            FROM firewall.events
            WHERE reported_at >= now() - interval '7 days'
            GROUP BY
                net_src_ip,
                net_dst_port,
                net_ttl,
                net_window,
                net_flag_syn,
                net_flag_ack,
                net_flag_rst
            ORDER BY hits DESC
            LIMIT 50;
