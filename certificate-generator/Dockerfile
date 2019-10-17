FROM debian:buster-slim

RUN apt update \
    && apt install --assume-yes curl \
    && curl --location --output /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.0/mkcert-v1.4.0-linux-amd64 \
    && chmod +x /usr/local/bin/mkcert \
    && apt autoremove --purge --assume-yes curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/ssl

CMD mkcert -install && for i in $(echo $DOMAINS | sed "s/,/ /g"); do mkcert ${i}; done
