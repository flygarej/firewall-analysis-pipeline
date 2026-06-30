SELECT net_src_ip, count(*) AS hits
            FROM firewall.events
            WHERE reported_at >= now() - interval '7 days'
            GROUP BY net_src_ip
            ORDER BY hits DESC
            LIMIT 30;
	    
