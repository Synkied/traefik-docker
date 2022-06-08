# Usage

- Clone this repository to your server.
- Create a docker network on your server: `docker network create traefik-proxy`
- Edit your projects `docker-compose.yml` files to use this new network.

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
### traefik.yml
- Place your email in place of `YOUR_EMAIL`
- Place your provider name in place of `YOUR_PROVIDER`, see https://doc.traefik.io/traefik/https/acme/#providers

### Your apps docker-compose.yml files

Place these labels under your nginx/apache container config, replacing `EXAMPLE.COM` by your domain name.
```
services:
 nginx:
  labels:
    - 'traefik.enable=true'
    - "traefik.http.routers.lingyuai_front_nginx.entrypoints=http"
    - 'traefik.http.routers.lingyuai_front_nginx.rule=Host(`EXAMPLE.COM`)'
    - "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme=https"
    - "traefik.http.routers.lingyuai_front_nginx.middlewares=traefik-https-redirect"
    - "traefik.http.routers.lingyuai_front_nginx-secure.entrypoints=https"
    - "traefik.http.routers.lingyuai_front_nginx-secure.rule=Host(`EXAMPLE.COM`)"
    - "traefik.http.routers.lingyuai_front_nginx-secure.tls=true"
    - "traefik.http.routers.lingyuai_front_nginx-secure.tls.certresolver=le"
    - "traefik.http.routers.lingyuai_front_nginx-secure.tls.domains[0].main=EXAMPLE.COM"
    - "traefik.http.routers.lingyuai_front_nginx-secure.tls.domains[0].sans=*.EXAMPLE.COM"
```

## Providers
### OVH
https://www.grottedubarbu.fr/traefik-dns-challenge-ovh/