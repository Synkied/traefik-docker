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
- Place your provider name in place of `YOUR_PROVIDER`, see https://doc.traefik.io/traefik/https/acme/#providers

### docker-compose.yml
- Change `traefik.yourdomain.com` with your desired endpoint to access traefik on your server
- If needed, uncomment lines about auth, and define a user/password combination

### Your apps docker-compose.yml files

Place these labels under your nginx/apache container config, replacing `EXAMPLE.COM` by your domain name.
```
services:
 nginx:
  labels:
    - 'traefik.enable=true'
    - "traefik.http.routers.nginx.entrypoints=http"
    - 'traefik.http.routers.nginx.rule=Host(`EXAMPLE.COM`)'
    - "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme=https"
    - "traefik.http.routers.nginx.middlewares=traefik-https-redirect"
    - "traefik.http.routers.nginx-secure.entrypoints=https"
    - "traefik.http.routers.nginx-secure.rule=Host(`EXAMPLE.COM`)"
    - "traefik.http.routers.nginx-secure.tls=true"
    - "traefik.http.routers.nginx-secure.tls.certresolver=le"
    - "traefik.http.routers.nginx-secure.tls.domains[0].main=EXAMPLE.COM"
    - "traefik.http.routers.nginx-secure.tls.domains[0].sans=*.EXAMPLE.COM"
```

## Providers
### OVH
https://www.grottedubarbu.fr/traefik-dns-challenge-ovh/