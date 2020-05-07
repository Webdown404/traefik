FROM alpine:3.11

RUN wget -O /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
  && chmod +x /usr/local/bin/mkcert \
  && mkdir /var/ssl

COPY generate-certificates.sh /tools/generate-certificates.sh

CMD ["/tools/generate-certificates.sh"]
