FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl --location --output /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.2.0/mkcert-v1.2.0-linux-amd64 \
    && chmod +x /usr/local/bin/mkcert

WORKDIR /var/ssl

CMD mkcert -install && for i in $(echo $DOMAINS | sed "s/,/ /g"); do mkcert ${i}; done
