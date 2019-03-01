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
            - "traefik.frontend.rule=Host:www.myproject.local"
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