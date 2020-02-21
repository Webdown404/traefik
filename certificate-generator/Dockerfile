FROM debian:buster-slim

RUN apt update \
    && apt install --assume-yes curl \
    && curl --location --output /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
    && chmod +x /usr/local/bin/mkcert \
    && apt autoremove --purge --assume-yes curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/ssl

COPY generate-certificates.sh /tools/generate-certificates.sh

CMD ["/tools/generate-certificates.sh"]
