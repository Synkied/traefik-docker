# Usage

- Clone this repository on your server.
- Create a docker network on your server: `docker network create traefik-proxy`
- Edit your projects `docker-compose.yml` files to use this new network, like so:

```
services:
 webapp:
  networks:
  - traefik-proxy
  ... anything else

networks:
  traefik-proxy:
    external: true
```

## Update files
### acme.json
Set permissions to 600 on for this file on your server, otherwise traefik won't perform SSL verifications.
`chmod 600 acme.json`

Associated error message: `unable to get ACME account: permissions 664 for acme.json are too open, please use 600`

### traefik.yml
- Place your email in place of `YOUR_EMAIL`

### docker-compose.yml
- Change `traefik.yourdomain.com` with your desired endpoint to access traefik on your server
- If needed, uncomment lines about auth, and define a user/password combination

### Your apps docker-compose.yml files

Place these labels under your nginx/apache container config, replacing `EXAMPLE.COM` by your domain name.
```
services:
 nginx_proxy:
  labels:
  - "traefik.enable=true"
  - "traefik.http.routers.nginx_proxy.entrypoints=http"
  - "traefik.http.routers.nginx_proxy.rule=Host(`${DOMAIN_NAME}`) || Host(`www.${DOMAIN_NAME}`)"
  - "traefik.http.routers.nginx_proxy.middlewares=redirect-to-https@file"
  - "traefik.http.routers.nginx_proxy-secure.entrypoints=https"
  - "traefik.http.routers.nginx_proxy-secure.rule=Host(`${DOMAIN_NAME}`) || Host(`www.${DOMAIN_NAME}`)"
  - "traefik.http.routers.nginx_proxy-secure.middlewares=redirect-to-non-www@file"
  - "traefik.http.routers.nginx_proxy-secure.tls=true"
  - "traefik.http.routers.nginx_proxy-secure.tls.certresolver=myresolver"
```
Where `myresolver` could be `le` if you want to use letsencrypt.
Where `DOMAIN_NAME` is a variable set in your `.env` file or somewhere else, see https://docs.docker.com/compose/environment-variables/

## Providers
### OVH
https://www.grottedubarbu.fr/traefik-dns-challenge-ovh/