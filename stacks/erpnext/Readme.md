Create Portainer config "erp-mariadb"

```
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
server-id        = 1
expire_logs_days = 10
binlog_format    = row
log_bin          = /var/log/mysql/mysql-bin
 
[mysql]
default-character-set = utf8mb4
```

![alt text](https://raw.githubusercontent.com/suodrazah/docker_swarm/main/_images/deploy_config.png)

Stack Environment Variables

- `ERPNEXT_VERSION` - v13.5.0
- `FRAPPE_VERSION` - v13.5.0
- `DOMAIN` - subdomain.example.domain
- `NODE` - manager, worker1, etc
- `STACK` - name of this stack for traefik reference
- `MARIADB_HOST` - mariadb, feel free to use external
- `MYSQL_ROOT_PASSWORD` - somepassword
- `ADMIN_PASSWORD` - somepassword
