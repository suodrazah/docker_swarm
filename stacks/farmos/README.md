Until I can be bothered adding a fix, for now after creating your site please append container file /var/www/html/sites/all/settings.php with
```
$base_url = 'https://www.example.com';
```

Stack Environment Variables
```
DOMAIN=subdomain.example.domain
NODE=manager, worker1, etc
STACK=name of this stack for traefik reference
MYSQL_ROOT_PASSWORD=somepassword
MYSQL_PASSWORD=somepassword
SQLBAK_KEY=sqlbak key
```
