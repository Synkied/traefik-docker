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
Place your email in place of `YOUR_EMAIL`
Place your provider name in place of `YOUR_PROVIDER`, see https://doc.traefik.io/traefik/https/acme/#providers

