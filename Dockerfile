FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="Etc/UTC"

RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  dumb-init \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN curl -fL -o lightpanda https://github.com/lightpanda-io/browser/releases/download/nightly/lightpanda-x86_64-linux && \
  chmod a+x ./lightpanda

# The CDP endpoint has no authentication, so don't run it as root.
RUN useradd --create-home --uid 1000 lightpanda
USER lightpanda

EXPOSE 9222

# Lightpanda rejects (403) any request whose Host header is not an IP, localhost,
# or the --advertise-host value. Advertise Railway's private domain by default so
# clients can connect via <service>.railway.internal; set ADVERTISE_HOST to override
# (e.g. to your TCP proxy domain when connecting over the public network).
ENTRYPOINT ["dumb-init", "--"]
CMD ["sh", "-c", "exec ./lightpanda serve --host :: --port 9222 --advertise-host \"${ADVERTISE_HOST:-${RAILWAY_PRIVATE_DOMAIN:-127.0.0.1}}\""]
