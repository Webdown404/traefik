# Traefik

## Configuration

Create external docker network

```console
> docker network create traefik
```

Add label to link backend service to traefik frontend

```yaml
services:
    webserver:
        labels:
            traefik.enable: true
            traefik.http.routers.www-myproject.entrypoints: http
            traefik.http.routers.www-myproject.rule: Host(`www.myproject.local`)
            traefik.http.routers.secure-www-myproject.entrypoints: https
            traefik.http.routers.secure-www-myproject.rule: Host(`www.myproject.local`)
            traefik.http.routers.secure-www-myproject.tls: true
            traefik.http.services.secure-www-myproject.loadbalancer.server.port: 80
```

Add DNS resolution to your localhost

```console
echo "127.0.0.1 www.myproject.local" >> /etc/hosts
```

## Run

Start traefik

```console
> docker-compose up -d
```

You can check traefik api to [localhost:8080](localhost:8080)

You application is available to [www.myproject.local](www.myproject.local)