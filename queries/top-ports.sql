            SELECT net_dst_port, count(*) AS hits
            FROM firewall.events
            WHERE reported_at >= now() - interval '7 days'
            GROUP BY net_dst_port
            ORDER BY hits DESC
            LIMIT 30;
