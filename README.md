# Traefik

A reverse proxy for local web development with docker-compose

## Traefik Installation

Clone repo

```console
> git clone git@github.com:Webdown404/traefik.git traefik
> cd traefik
```

Create external docker network to link docker services with traefik

```console
> docker network create traefik
```

Create external docker volume to store certificats

```console
> docker volume create traefik-certificats
```

Start traefik

```console
> docker-compose up -d
```

You can check traefik dashboard to [localhost:8080](localhost:8080)

## Configure a local docker-compose service to use traefik

Traefik will configure routers and services by listening docker api. You have to add labels in your webserver service to create a new `www-myproject` http router with Traefik

```yaml
services:
    [...]
    webserver:
        labels:
            traefik.enable: true
            traefik.http.routers.www-myproject.entrypoints: http
            traefik.http.routers.www-myproject.rule: Host(`www.myproject.local`)
        network:
            - default
            - traefik
```

Add DNS resolution to your localhost

```console
> echo "127.0.0.1 www.myproject.local" >> /etc/hosts
```

You application is now available to [http://www.myproject.local](http://www.myproject.local)

## Enable SSL with the default self signed Traefik certificat

To configure traefik in order to use the defaut traefik self signed certificat, you have to configure a new dedicated `secure-www-myproject` https router in your webserver service of your project as follow

```yaml
services:
    [...]
    webserver:
        labels:
            traefik.enable: true
            [...] # http traefik configuration labels
            traefik.http.routers.secure-www-myproject.entrypoints: https
            traefik.http.routers.secure-www-myproject.rule: Host(`www.myproject.local`)
            traefik.http.routers.secure-www-myproject.tls: true
        network:
            - default
            - traefik
```

You application is now available to [https://www.myproject.local](https://www.myproject.local)

> **Note** : This configuration use a self signed certificat. That's why you will see a CA security alert.

## Enable SSL with a CA validated mkcert certificat 

To avoid CA security alerts you can use mkcert to generate certificates validated by the mkcert CA.

### Generate Certificat

Override this docker-compose configuration with a `docker-compose.override.yml` by configuring the `domains` environment variable  to the `certificat-generator` service as follow

```yaml
version: '3.7'

services:
    certificat-generator:
        environment:
            domains: 'www.myproject.local'
```

> **Note** : 
> - You can generate multiple certificats with a comma separator (e.g. `domains: 'www.myproject.local,www.otherproject.local'`)
> - You can generate wildcard certificat like this `*.myproject.local`

Generate your certificate

```console
> docker-compose run certificat-generator
```

### Configure Traefik to use the mkcert generated certificat

To configure Traefik to use your mkcert generated certificat you have to create a `config.yaml` configuration file into `./reverse-proxy/conf.d/config.yaml`. In the file you have to add your certificate as follow :

```yaml
tls:
  certificates:
    - certFile: "/var/ssl/www.myproject.local.pem"
      keyFile: "/var/ssl/www.myproject.local-key.pem"
```

### Add mkcert CA to your browser

The `certificat-generator` service will generate a `rootCA.pem` into `/root/.local/share/mkcert` that you have to add to your browser in order to validate mkcert certificat. This file is generated into the `certificat-generator` service but not in your host.

To give `rootCA.pem` access to your host you can mount a volume between your host and the `certificat-generator` service by editing the `docker-compose.override.yml` file as follow

```yaml
services:
    certificat-generator:
        [...]
        volumes:
            - /usr/local/share/ca-certificates/docker:/root/.local/share/mkcert
```

> **Note** : Don't forget to restart your docker-compose project to update your configuration with `docker-compose up -d`

Now your `rootCA.pem` is available into `/usr/local/share/ca-certificates/docker/rootCA.pem`. You just have to add this file to your browser :
- for google chrome : [https://support.google.com/chrome/a/answer/6342302?hl=en](https://support.google.com/chrome/a/answer/6342302?hl=en)
- for firefox : [https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox](https://support.mozilla.org/en-US/kb/setting-certificate-authorities-firefox)
