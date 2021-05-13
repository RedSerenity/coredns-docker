ARG ALPINE_VERSION=3.12
ARG GO_VERSION=1.16.3
ARG COREDNS_VERSION=1.8.3

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS Builder
ARG COREDNS_VERSION

WORKDIR /src
RUN apk add --no-cache git make && \
		git clone https://github.com/coredns/coredns.git . && \
		git checkout v${COREDNS_VERSION}

COPY plugin.cfg plugin.cfg

RUN go get \
		github.com/coredns/alternate \
		github.com/openshift/coredns-mdns \
		github.com/miekg/dump \
		github.com/redserenity/coredns-plugins && \
		go mod tidy

RUN make && ./coredns -version



FROM alpine:${ALPINE_VERSION}
ARG COREDNS_VERSION

LABEL org.opencontainers.image.title="CoreDNS+"
LABEL org.opencontainers.image.authors="Tyler Andersen <tyler@redserenity.com>"
LABEL org.opencontainers.image.version="${COREDNS_VERSION}"
LABEL coredns_external_plugins="pdsql, redis, redis_cache, netbox, alternate, mdns, dump"

RUN set -xe && \
    apk add --no-cache bind-tools ca-certificates openssl curl dumb-init && \
    update-ca-certificates

COPY --from=Builder /src/coredns /usr/bin/coredns

EXPOSE 53 53/udp

VOLUME ["/etc/coredns/"]

ENTRYPOINT ["dumb-init"]

CMD ["/usr/bin/coredns", "-conf", "/etc/coredns/Corefile"]
