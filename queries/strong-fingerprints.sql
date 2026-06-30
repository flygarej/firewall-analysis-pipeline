	SELECT
    	    net_src_ip,
    	    net_seq,
    	    net_ttl,
    	    net_window,
    	    count(*) AS hits,
    	    count(DISTINCT net_dst_ip) AS dst_ips,
    	    count(DISTINCT net_dst_port) AS dst_ports,
    	    min(reported_at) AS first_seen,
    	    max(reported_at) AS last_seen
	FROM firewall.events
	WHERE net_protocol = 'tcp'
  	    AND net_flag_syn
  	    AND net_seq IS NOT NULL
  	    AND net_ttl IS NOT NULL
  	    AND net_window IS NOT NULL
	GROUP BY net_src_ip, net_seq, net_ttl, net_window
	HAVING count(*) >= 3
	ORDER BY hits DESC;
