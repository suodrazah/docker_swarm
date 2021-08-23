### <p align="center">ERPNext Deployment with optional additional apps</p>

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

![alt text](https://raw.githubusercontent.com/suodrazah/docker_swarm/main/_images/deploy_conf.png)

Stack Environment Variables
```
ERPNEXT_VERSION=v13.9.2
FRAPPE_VERSION=v13.9.0
INSTALL_APPS=erpnext,posawesome,frappe_s3_attachment,metabase_integration,bookings,bench_manager - available apps
DOMAIN=subdomain.example.domain
NODE=manager, worker1, etc
STACK=name of this stack for traefik reference
MARIADB_HOST=mariadb, feel free to use external
MYSQL_ROOT_PASSWORD=somepassword
ADMIN_PASSWORD=somepassword
SQLBAK_KEY=Key for connection to sqlbak, uncomment if you want to use this service
```
