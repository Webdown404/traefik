FROM golang:1 as mkcert
RUN apt update \
  && apt install -y git \
  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/FiloSottile/mkcert \
  && cd mkcert \
  && go build -ldflags "-X main.Version=$(git describe --tags)"

FROM alpine:3
RUN apk add --no-cache gcompat
COPY --from=mkcert /go/mkcert/mkcert /usr/bin/mkcert
COPY generate-certificates.sh /tools/generate-certificates.sh
CMD ["/tools/generate-certificates.sh"]