1.Create Portainer config "erp-mariadb"

\##\ Start of erp-mariadb \##\
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
 
[mysql]
default-character-set = utf8mb4
\##\ End of erp-mariadb \##\

2. Set Stack Environment Variables

ERPNEXT_VERSION=v13.4.1
FRAPPE_VERSION=v13.4.1
DOMAIN=subdomain.example.domain
NODE=manager, worker1, etc
STACK=name of this stack for traefik reference
MARIADB_HOST=mariadb, feel free to use external
MYSQL_ROOT_PASSWORD=somepassword
ADMIN_PASSWORD=somepassword

3. Copy contents of stack into web editor and click deploy.
