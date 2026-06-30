            SELECT imported_at, source_host, source_path, source_size, row_count
            FROM firewall.imported_files
            ORDER BY imported_at DESC
            LIMIT 20;
