Stack Environment Variables

```
DOMAIN=subdomain.example.domain
NODE=manager, worker1, etc
STACK=name of this stack for traefik reference
MYSQL_ROOT_PASSWORD=somepassword
MYSQL_PASSWORD=somepassword
IGPASSWORD=Ignition admin password
```

Ignition Gateway Database Connection Setup

- `JDBC Driver` - MariaDB
- `user` - db
- `URL` - jdbc:db://db:3306/db
