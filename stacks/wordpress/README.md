Create Portainer config "wordpress-mariadb"
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
DOMAIN=subdomain.example.domain
MYSQL_PASSWORD=Wordpress Database Password
MYSQL_ROOT_PASSWORD=Mariadb root password
SQLBAK_KEY=sqlbak key
STACK=Stack name
NODE=NodeID
```
