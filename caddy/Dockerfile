# syntax=docker/dockerfile:1
FROM caddy:2.9-builder AS builder
RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/mholt/caddy-l4

FROM caddy:2.9 AS caddy
COPY --from=builder /usr/bin/caddy /usr/bin/caddy