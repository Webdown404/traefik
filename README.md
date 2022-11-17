# Traefik

A reverse proxy for local web development with Docker Compose.

## Requirements

This stack require :
- `docker` and `docker-compose` ([https://github.com/docker](https://github.com/docker))
- `task` ([https://github.com/go-task/task](https://github.com/go-task/task))

## Traefik Installation

Clone the repository:

```console
> git clone git@github.com:Webdown404/traefik.git
> cd traefik
```

Create external Docker network to link other Docker Compose services with Traefik and create external Docker volume to store certificates:

```console
> task setup
```

Copy `docker-compose.override.yml.dist` to `docker-compose.override.yml` and tweak it to your needs; then start Traefik:

```console
> task start
```

You can check Traefik dashboard at [localhost:8080](http://localhost:8080) or with Taskfile with:

```console
> task open-dashboard
```

## Configure a local Docker Compose service to use Traefik

Traefik will configure routers and services by listening Docker API. You need to:
 - declare the external `traefik` network;
 - link the webserver to the network;
 - add labels to your webserver to create a new named (e.g. `www-myproject`) HTTP router with Traefik.

```yaml
services:
    # ...
    webserver:
        labels:
            traefik.enable: true
            traefik.http.routers.www-myproject.entrypoints: http
            traefik.http.routers.www-myproject.rule: Host(`www.myproject.local`)
        networks:
            - default
            - traefik

networks:
    traefik:
        external: true
```

Add DNS resolution to your localhost:

```console
> echo "127.0.0.1 www.myproject.local" | sudo tee -a /etc/hosts
```

You application is now available at [http://www.myproject.local](http://www.myproject.local).

## HTTPS

To make your webserver available through HTTPS, add dedicated (e.g. `secure-www-myproject`) routing labels to the webserver service of your project as follows:

```yaml
services:
    # ...
    webserver:
        labels:
            traefik.enable: true
            # ...
            traefik.http.routers.secure-www-myproject.entrypoints: https
            traefik.http.routers.secure-www-myproject.rule: Host(`www.myproject.local`)
            traefik.http.routers.secure-www-myproject.tls: true
```

You application is now available at [https://www.myproject.local](https://www.myproject.local).

> **Note**: This configuration uses a self-signed certificate. That's why you will see a CA security alert.

## Trusted Certificates

To allow HTTPS, this project uses [mkcert](https://github.com/FiloSottile/mkcert) to generate trusted self-signed SSL certificates.

### Generate Certificates

Make sure the `DOMAINS` environment variable in `docker-compose.override.yml` lists all the domains you need:

```yaml
services:
    certificate-generator:
        environment:
            DOMAINS: 'www.myproject.local'
```

> **Note**:
> - You can generate multiple certificates with a space separator (e.g. `DOMAINS: 'www.myproject.local www.otherproject.local'`)
> - You can generate wildcard certificates, e.g.: `*.myproject.local`

Generate the certificates:

```console
> task generate-certificate
```

### Make your system trust mkcert certificates

In order to trust mkcert CA, you have to add generated CA certificate to your system:

```console
> task install-ca-certificate
```
